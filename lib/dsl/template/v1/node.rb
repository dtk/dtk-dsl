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
      require_relative('node/semantic_parse')
      module Constant
        module Variations
        end

        extend ClassMixin::Constant
        Name        = 'name'
        Attributes  = 'attributes'
        Components  = 'components'
      end

      ### For parsing
      def self.elements_collection_type
        :hash
      end

      def self.parse_elements(input_hash, parent_info)
        input_hash.inject(file_parser_output_hash) do |h, (name, content)|
          h.merge(name => parse_element(content, parent_info, :index => name))
        end
      end

      def parse!
        set? :Attributes, parse_child_elements?(:node_attribute, :Attributes)
        set? :Components, parse_child_elements?(:component, :Components)
      end

      ### For generation
      def self.generate_elements(nodes_content, parent)
        nodes_content.map do |name, node|
          if node_hash = generate_element?(node, parent)
            node_hash.empty? ? "node[#{name}]" : { "node[#{name}]" => node_hash[:content] }
          end
        end.compact
      end

      def generate!
        merge(:content => generate_node_hash.flatten)
      end

      private

      def generate_node_hash
        ret = []

        ret << { 'attributes' => generate_child_elements(:node_attribute, val(:Attributes)) }
        ret << generate_child_elements(:component, val(:Components))

        ret
      end

    end
  end
end

