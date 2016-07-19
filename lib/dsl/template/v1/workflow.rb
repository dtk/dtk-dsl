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

      # TODO: DTK-2554 Aldin: need to refactor this
      def parse!
        # TODO: catchall
        merge(parse_and_ret_workflow(input_hash))
      end

      def parse_and_ret_workflow(input_hash, opts = {})
        ret = input_hash.inject({}) do  |h, (workflow_action, r)|
          workflow_hash = r || {}
          # we explicitly want to delete from workflow_hash; workflow_action can be nil
          # action_under_key = (workflow_hash.kind_of?(Hash) ? workflow_hash.delete(Constant::WorkflowAction) : nil)
          # workflow_action = r[:action] || action_under_key
          parsed_workflow = parse_workflow(workflow_hash, workflow_action, {}, opts)
          h.merge(parsed_workflow)
        end

        ret
      end

      def parse_workflow(workflow_hash, workflow_action, assembly_hash, opts = {})
        # raise_error_if_parsing_error(workflow_hash, workflow_action, opts)
        # check_if_invalid_component_in_workflow(assembly_hash, workflow_hash)

        normalized_workflow_action =
          if opts[:service_module_workflow]
            normalized_service_module_action(workflow_hash, workflow_action)
          else
            normalized_assembly_action(workflow_action)
          end

        task_template_ref = normalized_workflow_action
        task_template = {
          'task_action' => normalized_workflow_action,
          'content'     => workflow_hash
        }

        { task_template_ref => task_template }
      end

      def raise_error_if_parsing_error(workflow_hash, workflow_action, opts = {})
        if parse_error = Task::Template::ConfigComponents.find_parse_error?(workflow_hash, {workflow_action: workflow_action}.merge(opts))
          fail parse_error
        end
      end

      def normalized_service_module_action(workflow_hash, workflow_action)
        workflow_action || workflow_hash['name']
      end

      def normalized_assembly_action(workflow_action)
        if workflow_action.nil? or Constant.matches?(workflow_action, :CreateWorkflowAction)
          '__create_action'
        else
          workflow_action
        end
      end
    end
  end
end

# TODO: DTK-2554: workflows: Aldin: 
# here is an example of output form for one element; this is vcase that is treated specially; if match
# CreateWorkflowAction use __create_action
=begin

{"__create_action"=>
  {"task_action"=>"__create_action",
   "content"=>
    {"subtasks"=>
      [{"name"=>"bigtop_multiservice", "components"=>["bigtop_multiservice"]},
       {"name"=>"bigtop hiera", "components"=>["bigtop_multiservice::hiera"]},
       {"name"=>"bigtop_base", "components"=>["bigtop_base"]},
       {"name"=>"namenode", "components"=>["hadoop::namenode"]},
       {"name"=>"if needed leave safemode",
        "actions"=>["hadoop::namenode.leave_safemode"]},
       {"name"=>"namenode smoke test",
        "actions"=>["hadoop::namenode.smoke_test"]},
       {"name"=>"datanodes",
        "ordered_components"=>["hadoop::common_hdfs", "hadoop::datanode"]},
       {"name"=>"hdfs directories for spark",
        "component"=>["hadoop::hdfs_directories"]},
       {"name"=>"spark master and client",
        "components"=>["spark::master", "spark::client"]},
       {"name"=>"spark workers",
        "ordered_components"=>["spark::common", "spark::worker"]},
       {"name"=>"zeppelin server", "components"=>["zeppelin::server"]}]}}}
=end
