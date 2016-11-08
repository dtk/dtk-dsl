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
      # TODO: do we want workflow/semantic_parse
      require_relative('workflow/semantic_parse')

      module Constant
        module Variations
        end
        
        extend ClassMixin::Constant
        Import       = 'import'
        Name         = 'name'
        SubtaskOrder = 'subtask_order'
        Subtasks     = 'subtasks'
        Flatten      = 'flatten'
      end

      ### For parsing
      
      def parser_output_type
        :hash
      end
      
      def self.parse_elements(input_hash, parent_info)
        input_hash.inject(file_parser_output_hash) do |h, (name, workflow)|
          h.merge(name => parse_element(workflow, parent_info, :index => name))
        end
      end
      
      def parse!
        merge parse_workflow(input_hash)
      end

      ### For generation
      def self.generate_elements(workflows_content, parent)
        workflows_content.inject({}) do |h, (name, workflow)| 
          h.merge(name => generate_element(workflow, parent))
        end
      end

      def generate!
        set? :Name, val(:Name)
        set? :SubtaskOrder, val(:SubtaskOrder)
        if subtasks = val(:Subtasks)
          generated_subtasks = subtasks.map do |subtask|
            generated_subtask = generate_subtask(subtask)
            generated_subtask.empty? ? nil : generated_subtask
          end.compact
          set :Subtasks, generated_subtasks unless generated_subtasks.empty?
        end
        merge(uninterpreted_keys)
      end
      
      private

      def generate_subtask(subtask)
        self.class.create_for_generation(subtask, :top => @top, :filter => @filter).generate_yaml_object
      end

      INTERPRETED_KEYS = [Constant::Name, Constant::SubtaskOrder, Constant::Subtasks, Constant::Flatten, Constant::Import]
      def uninterpreted_keys
        (@content.keys - INTERPRETED_KEYS).inject({}) do |h, k| 
          h.merge(k.to_s => change_symbols_to_strings(@content[k]))
        end
      end
      
      def change_symbols_to_strings(obj)
        if obj.kind_of?(::Hash)
          obj.inject({}) { |h, (k, v)| h.merge(k.to_s => change_symbols_to_strings(v)) }
        elsif obj.kind_of?(::Array)
          obj.map { |el| change_symbols_to_strings(el) }
        elsif obj.kind_of?(::Symbol)
          obj.to_s
        else
          obj
        end
      end

      
      def parse_workflow(workflow_hash)
        # TODO: put in fine grain parsing of workflow_hash
        workflow_hash
      end

    end
  end
end

