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
module DTK::DSL
  class Template
    class V1
      class Component < self
        require_relative('component/semantic_parse')

        module Constant
          module Variations
          end
          
          extend ClassMixin::Constant

          Attributes     = 'attributes'
          ComponentLinks = 'component_links'
        end

        ### For parsing
        def parser_output_type 
          :hash
        end

        def self.elements_collection_type
          :array
        end
        
        def self.parse_elements(input_array, parent_info)
          input_array.inject(file_parser_output_hash) do |h, component|
            name = name(component)
            h.merge(name => parse_element(component, parent_info, :index => name))
          end
        end

        def parse!
          # TODO: This is a catchall that removes ones we so far are parsing and then has catch all
          if input_string?
            parse_when_string!
          elsif input_hash = input_hash?
            parse_when_hash!
          else
            raise parsing_error(:WrongObjectType, @input, [::String, ::Hash])
          end
        end

        ### For generation
        def self.generate_elements(components_content, parent)
          components_content.map do |name, component| 
            if component_hash = generate_element?(component, parent)
              component_hash.empty? ? name : { name => component_hash }
            end
          end.compact
        end

        def generate!
          merge(generate_component_hash)
        end

        # Ovewritting this function because dont want to return nil when empty content
        def generate_yaml_object?
          generate! unless skip_for_generation?
        end
        
        private

        def generate_component_hash
          ret = {}
          set_generation_hash(ret, :Attributes, generate_child_elements(:attribute, val(:Attributes)))
          #TODO: set component_links
          ret
        end
        
        def self.name(input)
          if input.kind_of?(::String)
            input
          elsif input.kind_of?(::Hash) and input.size > 0
            input.keys.first
          else
            raise parsing_error(:WrongObjectType, input, [::String, ::Hash])
          end
        end
        
        def name
          self.class.name(@input)
        end
        
        def parse_when_string!
        end

        def parse_when_hash!
          unless input_hash.size == 1 and input_hash.values.first.kind_of?(::Hash)
            raise parsing_error("Component is ill-formed; it must be string or hash")
          end
          properties = input_hash.values.first
          set? :Attributes, parse_child_elements?(:attribute, :Attributes, :input_hash => properties)

          # TODO: This is a catchall that removes ones we so far are parsing and then has catch all
          properties.delete('attributes')
          merge properties
        end

      end
    end
  end
end

