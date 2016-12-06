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
  class ServiceAndComponentInfo::TransformTo
    class Parser::TopDSL
      class Dependencies < self
        NAMESPACE_NAME_DELIM = '/'
        COMPONENT_NAME_DELIM = '::'

        def update_output_hash?
          if module_input_file = input_files?(:module)
            module_input_hash = module_input_file.content_hash
            unless module_input_hash.empty?
              components   = []
              dependencies = module_input_hash['dependencies'] || {}
              hash_content = get_hash_content_for_type(module_input_hash) || {}

              find_components!(hash_content, components)
              matching_component_dependencies = get_components_from_dependencies(dependencies, components)

              (output_hash['service_module_refs'] ||= {}).merge!('component_modules' => matching_component_dependencies)
            end
          end
        end

        def convert_to_hash(namespace_name, version)
          namespace, name = namespace_name.split(NAMESPACE_NAME_DELIM)
          { name => { 'namespace' => namespace, 'version' => version } }
        end
        
        private

        def get_hash_content_for_type(input_hash)
          case info_object
          when Info::Service
            input_hash['assemblies']
          when Info::Component
            input_hash['component_defs']
          else
            fail Error.new("Unsupported type #{type}!")
          end
        end

        def get_components_from_dependencies(dependencies, components)
          dependencies_array  = []
          service_module_refs = {}

          dependencies.each_pair do |name, version|
            dependencies_array << convert_to_hash(name, version)
          end

          components.each do |component|
            if matching_cmp = find_component_dependency_match(component, dependencies_array)
              service_module_refs.merge!(matching_cmp)
            end
          end

          service_module_refs
        end

        def find_component_dependency_match(component, dependencies)
          cmp_name = component.include?(COMPONENT_NAME_DELIM) ? component.split(COMPONENT_NAME_DELIM).first : component
          dependencies.find{ |dep| dep[cmp_name] }
        end

        def find_components!(hash_content, components)
          hash_content.each do |name, content|
            if name.to_s.eql?('components')
              extract_components(content, components)
            elsif content.is_a?(Hash)
              find_components!(content, components)
            end
          end
        end

        def extract_components(content, components)
          content.each do |cmp|
            cmp_name =
              if cmp.is_a?(String)
                cmp
              elsif cmp.is_a?(Hash)
                cmp.keys.first
              else
                fail Error.new("Unknown component format #{cmp}!")
              end
            components << cmp_name
          end
        end
      end
    end
  end
end
