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
          component_links_content.inject({}) do |h, (component_link_name, component_link)| 
            component_link.set(:Name, component_link_name)
            element = generate_element?(component_link, parent)
            element.nil? ? h : h.merge(element)
          end
        end
        
        def generate!
          if dependent_component_ref = generate_dependent_component_ref?
            merge(req(:Name) => dependent_component_ref)
            self
          end
        end
        
        def generate?
          generate! unless skip_for_generation?
        end
        
        private
        
        def self.parse_transform_link_to_hash_form(link_input, parent)
          if link_input.kind_of?(::Hash)
            link_input
          elsif link_input.kind_of?(::String)
            { ImplicitLinkName.parse(link_input, parent)  => link_input }
          else
            parent.parsing_error(:WrongObjectType, link_input, [::Hash, ::String])
          end
        end

        # returns [dependency, external_service_name]; second can be nil
        def parse_value
          dependency = external_service_name = nil
          string = input_key_value(:Value)
          dependency, external_service_name = ExternalServiceName.parse?(string)
          dependency ||= string
          [dependency, external_service_name]
        end        

        def generate_dependent_component_ref?
          if component_ref = val(:Value)
            if external_service_name = val(:ExternalServiceName)
              ExternalServiceName.dependent_component_ref(external_service_name, component_ref)
            else
              component_ref
            end
          end
        end
        
        
        module ImplicitLinkName
          def self.parse(input_string, parent)
            last_component = input_string.split('/').last
            # remove title if it exists
            title_split = last_component.split('[')
            case title_split.size
            when 1
              return last_component
            when 2
              return title_split[0] if title_split[1] =~ /\]$/
            end
            raise parent.parsing_error("The term '#{input_string}' is an ill-formed component link dependency reference")
          end
        end
        
        module ExternalServiceName
          SERVICE_NAME_VAR = '*'
          COMPONENT_VAR = '+'
          MAPPINGS = {
            short_form: {
              generate: "#{SERVICE_NAME_VAR}/#{COMPONENT_VAR}",
              parse_regexp: /^([^\/\]\[]+)\/(.+$)/
            },
            long_form: {
              generate: "service[#{SERVICE_NAME_VAR}]/#{COMPONENT_VAR}",
              parse_regexp:  /^service\[([^\]]+)\]\/(.+$)/
            }
          }
          PARSE_REGEXPS = MAPPINGS.values.map { |info| info[:parse_regexp] }

          CANONICAL_FORM = :short_form
          
          def self.dependent_component_ref(external_service_name, component_ref)
            MAPPINGS[CANONICAL_FORM][:generate].sub(SERVICE_NAME_VAR, external_service_name).sub(COMPONENT_VAR, component_ref)
          end

          # returns [dependency, external_service_name] or nil if no external_service_name
          def self.parse?(input_string)
            # assume that cant have form ATOMIC-TERM/... where ATOMIC-TERM is not a external name
            PARSE_REGEXPS.each do |regexp|
              if input_string =~ regexp
                external_service_name, dependency = [$1, $2]
                return [dependency, external_service_name]
              end
            end
            nil
          end

        end
      end
    end
  end
end

