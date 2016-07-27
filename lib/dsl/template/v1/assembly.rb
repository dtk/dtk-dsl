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

        Workflows   = 'workflows'
        Variations::Workflows = ['workflows', 'workflow']

      end

      ### For parsing

      def self.parse_elements(input, parent_info)
        ret = file_parser_output_array
        input_hash(input).each do |name, content|
          ret << parse_element(content.merge('name' => name), parent_info, :index => name)
        end
        ret
      end

      def parse!
        set  :Name, input_key(:Name)
        set? :Description, input_key?(:Description)
        set? :Attributes, parse_child_elements?(:attribute, input_key?(:Attributes))
        set? :Nodes, parse_child_elements?(:node, input_key?(:Nodes))
        set? :Components, parse_child_elements?(:component, input_key?(:Components))
        set? :Workflows, parse_child_elements?(:workflow, input_key?(:Workflows))
    
        # TODO: This is a catchall that removes ones we so far are parsing and then has catch all
        input_hash.delete('name')
        input_hash.delete('description')
        input_hash.delete('attributes')
        input_hash.delete('nodes')
        input_hash.delete('components')
        input_hash.delete('workflow')
        input_hash.delete('workflows')
        merge input_hash
      end

      ### For generation
      def generate!
        # TODO: add attributes, workflows
        set :Description, val(:Description)
        set :Components, generate_child_elements(:component, val(:Components))
        set :Nodes, generate_child_elements(:node, val(:Nodes))
      end

    end
  end
end

