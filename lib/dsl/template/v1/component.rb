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

          Components        = 'components'
          Attributes        = 'attributes'
          Links             = 'links'
          ComponentLinks    = 'component_links'
          Variations::ComponentLinks = ['links', 'component_links', 'component_link']

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
            name = name(component, :parent => parent_info.parent)
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
          set_generation_hash(ret, :Links, generate_child_elements(:component_link, val(:ComponentLinks)))
          set_generation_hash(ret, :Components, generate_child_elements(:component, val(:Components)))
          ret
        end
        
        # opts can have keys:
        #  :parent
        #  :this
        # Will not have both keys
        def self.name(input, opts = {})
          if input.kind_of?(::String)
            input
          elsif input.kind_of?(::Hash) and input.size > 0
            input.keys.first
          else
            raise (opts[:this] || opts[:parent]).parsing_error([:WrongObjectType, input, [::String, ::Hash]])
          end
        end
        
        def name
          self.class.name(@input, :this => self)
        end
        
        def parse_when_string!
        end

        def parse_when_hash!
          unless input_hash.size == 1 and input_hash.values.first.kind_of?(::Hash)
            raise parsing_error("Component is ill-formed; it must be string or hash")
          end

          properties = input_hash.values.first

          # removes from peroperties so we can simply merge keys not processed
          parse_set_property_value_and_remove!(properties, :Attributes)
          parse_set_property_value_and_remove__component_links!(properties)
          parse_set_property_value_and_remove!(properties, :Components)
          merge properties unless properties.empty?
        end

        # opts can have keys: 
        #   :matching_key_value
        def parse_set_property_value_and_remove!(properties, constant, opts = {})
          if matching_key_value = opts[:matching_key_value] || constant_class.matching_key_and_value?(properties, constant)
            key_in_properties   = matching_key_value.keys.first
            value               = matching_key_value.values.first
            canonical_key       = constant_class.canonical_value(constant) # this is string
            parse_template_type = canonical_key.sub(/s$/, '').to_sym

            # example what below looks like set? :Components, parse_child_elements?(:component, :Components, :input_hash => { 'components' => components})
            set? constant, parse_child_elements?(parse_template_type, constant, :input_hash => { canonical_key => value })
            properties.delete(key_in_properties)
          end
        end

        # This method handles synatic varaints where component links may be an array and can have array elements that are simple term meaning that
        #   the link name is the component type
        def parse_set_property_value_and_remove__component_links!(properties)
          constant = :ComponentLinks
          return unless matching_key_value = constant_class.matching_key_and_value?(properties, constant)
          key   = matching_key_value.keys.first
          value = matching_key_value.values.first
          transformed_value = ComponentLink.parse_transform_to_hash_form(value, self)
          parse_set_property_value_and_remove!(properties, constant, matching_key_value: { key => transformed_value })
        end

      end
    end
  end
end

