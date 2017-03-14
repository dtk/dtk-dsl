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
    class Assembly < self
      module Constant
        module Variations
        end

        extend ClassMixin::Constant
        Name        = 'name'
        Description = 'description'
        Attributes  = 'attributes'
        Nodes       = 'nodes'
        Components  = 'components'
        Target      = 'target'

        Actions     = 'actions'
        Workflows   = 'workflows'
        Variations::Workflows = ['actions', 'workflows', 'workflow']

      end

      ### For parsing

      def self.elements_collection_type
        :hash
      end

      def yaml_object_type
        :array
      end

      def self.parse_elements(input_hash, parent_info)
        ret = file_parser_output_array
        input_hash.each do |name, content|
          ret << parse_element(content.merge('name' => name), parent_info, :index => name)
        end
        ret
      end

      def parse!
        remove_processed_keys_from_input_hash! do
          set  :Name, input_key_value(:Name)
          set? :Description, input_key_value?(:Description)
          set? :Target, input_key_value?(:Target)
          set? :Attributes, parse_child_elements?(:attribute, :Attributes)
          set? :Nodes, parse_child_elements?(:node, :Nodes)
          set? :Components, parse_child_elements?(:component, :Components)
          set? :Workflows, parse_child_elements?(:workflow, :Workflows)
        end
        # handle keys not processed
         merge input_hash unless input_hash.empty?
      end

      ### For generation
      def generate!
        # TODO: add attributes
        if description = val(:Description)
          add({'description' => description})
        end

        if target = val(:Target)
          add({'target' => target})
        end

        concat?(generate_child_elements(:component, val(:Components)))
        concat?(generate_child_elements(:node, val(:Nodes)))

        if workflows = generate_child_elements(:workflow, val(:Workflows))
          add({'actions' => workflows})
        end
      end

    end
  end
end

