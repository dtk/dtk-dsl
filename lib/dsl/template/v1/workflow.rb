#
# Copyright (C) 2010-2016 dtk contributors
#
# This file is part of the dtk project.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class DTK::DSL::Template
  class V1
    class Workflow < self
      # TODO: DTK-2554: workflows: Aldin: 
      # cut and paste from import_task_templates and its subfunctions in 
      # https://github.com/dtk/dtk-server/blob/DTK-2554/application/model/module/service_module/dsl/assembly_import/adapters/v4.rb
      # might break this into multiple files underneath this to handle sub parts of workflow
      # these dont have to be templates; just files included by # require_relative('workflow/...)
      module Constant
        module Variations
        end
        
        extend ClassMixin::Constant
        
        CreateWorkflowAction = 'create'
      end
      
      def parser_output_type
        :hash
      end
      
      def self.parse_elements(input, parent_info)
        workflows =
          if input_hash?(input)
            [input]
          elsif input_array?(input)
            input
          else
            raise parsing_error("Ill-formed workflow(s) section")
          end
        
        ret = file_parser_output_hash
        workflows.each_with_index do |workflow, i|
          ret.merge!(parse_element(workflow, parent_info, :index => name?(workflow) || i))
        end
        ret
      end
      
      def parse!
        input_hash.each_pair { |name, workflow_hash| merge(parse_workflow(name, workflow_hash)) }
      end
      
      private
      
      def self.name?(workflow)
        if input_hash?(workflow)
          workflow.keys.first if workflow.size == 1
        end
      end
      
      def parse_workflow(name, workflow_hash)
        # Put in fine grain parsing
        # TODO: change to canonical output form and make output be array that has canonical fields for workflow_hash
        # TODO: handle normalize create to be on server side
        normalized_name = normalized_name(name)
        { normalized_name => {
            'task_action' => normalized_name,
            'content'     => workflow_hash
          }
        }
      end
      
      INTERNAL_CREATE_ACTION_NAME = '__create_action'

      def normalized_name(name)
        if name.nil? or Constant.matches?(name, :CreateWorkflowAction)
          '__create_action'
        else
          name
        end

      end
    end
  end
end

