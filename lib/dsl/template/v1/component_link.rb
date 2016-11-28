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
    class ComponentLink < self
      require_relative('component_link/semantic_parse')

      module Constant
        module Variations
        end

        extend ClassMixin::Constant
        Value = 'value'
      end

      ### For parsing
      def parser_output_type
        :hash
      end

      def self.elements_collection_type
        :hash
      end

      def self.parse_elements(input_hash, parent_info)
        input_hash.inject(file_parser_output_hash) do |h, (name, value)|
          h.merge(name => parse_element({ 'value' => value}, parent_info, :index => name))
        end
      end

      def parse!
        # using 'input_key_value?' (i.e., with '?') in case null value
        set :Value, input_key_value?(:Value)
      end

      ### For generation
      def self.generate_elements(component_links_content, parent)
        component_links_content.inject({}) do |h, (component_link_name, component_link)| 
          component_link.set(:Name, component_link_name)
          element = generate_element?(component_link, parent)
          element.nil? ? h : h.merge(element)
        end
      end

      def generate!
        value = val(:Value)
        unless value.nil?
          merge(req(:Name) => val(:Value))
          self
        end
      end

      def generate?
        generate! unless skip_for_generation?
      end

    end
  end
end

