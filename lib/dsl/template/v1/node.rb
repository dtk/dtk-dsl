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
    class Node < self
      module Constant
        module Variations
        end

        extend ClassMixin::Constant
        Name        = 'name'
        Attributes  = 'attributes'
        Components  = 'components'
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
        set  :Name, input_key_value(:Name)
        set? :Attributes, parse_child_elements?(:attribute, :Attributes)
        set? :Components, parse_child_elements?(:component, :Components)

        # TODO: This is a catchall that removes ones we so far are parsing and then has catch all
        input_hash.delete('name')
        input_hash.delete('attributes')
        input_hash.delete('components')
        merge input_hash
      end

      ### For generation
      def self.generate_elements(nodes_content, parent)
        nodes_content.map { |node| generate_element?(node, parent) }.compact
      end

      def generate!
        merge(req(:Name) => generate_node_hash)
      end

      ### For diffs
      # TODO: ..

      private

      def generate_node_hash
        ret = {}
        set_generation_hash(ret, :Attributes, generate_child_elements(:attribute, val(:Attributes)))
        set_generation_hash(ret, :Components, generate_child_elements(:component, val(:Components)))
        ret
      end

    end
  end
end

