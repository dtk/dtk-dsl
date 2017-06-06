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
      class ComponentLink < self
        require_relative('component_link/semantic_parse')
        require_relative('component_link/implicit_link_name')
        require_relative('component_link/external_service_name')
        
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
        
        # Canonical form is an array
        def self.elements_collection_type
          :hash
        end
        
        def self.parse_elements(input_hash, parent_info)
          input_hash.inject(file_parser_output_hash) do |h, (name, value)|
            h.merge(name => parse_element({ 'value' => value}, parent_info, :index => name))
          end
        end
        
        def parse!
          dependency, external_service_name = parse_value
          set :Value, dependency
          set? :ExternalServiceName, external_service_name
        end
        
        def self.parse_transform_to_hash_form(input_links, parent)
          if input_links.kind_of?(::Hash)
            input_links
          elsif input_links.kind_of?(::Array)
            input_links.inject(empty_input_hash) { |h, link| h.merge(ComponentLink.parse_transform_link_to_hash_form(link, parent)) }
          else
            raise parent.parsing_error(:WrongObjectType, input_links, [::Hash, ::Array])
          end
        end
        
        ### For generation
        def self.generate_elements(component_links_content, parent)
          # Parsing form can be a hash, but canonical form is an array 
          component_links_content.map { |link_name, component_link| generate_canonical_element(link_name, component_link) }
        end

        private
        
        def self.parse_transform_link_to_hash_form(link_input, parent)
          if link_input.kind_of?(::Hash)
            link_input
          elsif link_input.kind_of?(::String)
            { ImplicitLinkName.parse(link_input, parent: parent) => link_input }
          else
            parent.parsing_error(:WrongObjectType, link_input, [::Hash, ::String])
          end
        end

        # returns [dependency, external_service_name]; second can be nil
        def parse_value
          dependency = external_service_name = nil

          string = input_key_value(:Value)
          # only the service instance dsl can have external service name
          if file_obj.file_type < FileType::ServiceInstance
            dependency, external_service_name = ExternalServiceName.parse?(string)
          end
          dependency ||= string
          [dependency, external_service_name]
        end        

        def self.generate_canonical_element(link_name, component_link)
          dependent_ref = dependent_component_ref(component_link)
          if ImplicitLinkName.implicit_link_name(dependent_ref) == link_name
            dependent_ref
          else
            { link_name => dependent_ref }
          end
        end

        def self.dependent_component_ref(component_link)
          component_ref = component_link.req(:Value)
          if external_service_name = component_link.val(:ExternalServiceName)
            ExternalServiceName.dependent_component_ref(external_service_name, component_ref)
          else
            component_ref
          end
        end
      end
    end
  end
end

