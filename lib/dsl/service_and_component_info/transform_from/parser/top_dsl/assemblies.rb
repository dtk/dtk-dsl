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
  class ServiceAndComponentInfo::TransformFrom::Parser
    class TopDSL
      class Assemblies < self
        require_relative('assemblies/workflows')
        require_relative('assemblies/node_bindings')
        def update_output_hash?
          input_files(:assemblies).content_hash_array.each do |input_hash|
            name          = input_hash['name'] || raise_error_missing_field('name')
            assembly_hash = input_hash['assembly'] || raise_error_missing_field('assembly')

            assembly_content = []
            if description = input_hash['description']
              assembly_content << { 'description' => description }
            end

            if node_bindings = input_hash['node_bindings']
              # convert node_bindings to node attributes
              NodeBindings.add_node_properties!(assembly_content, node_bindings) 
            end

            assembly_hash = convert_old_to_new_format(assembly_hash) if is_old_format?(assembly_hash)
            assembly_content << assembly_hash

            if workflows = Workflows.hash_content?(input_hash)
              assembly_content << { 'workflows' => workflows }
            end

            (output_hash['assemblies'] ||= {}).merge!(name => assembly_content.flatten)
          end
        end

        private

        def is_old_format?(assembly_hash)
          assembly_hash.key?('nodes') || assembly_hash.key?('components')
        end

        def convert_old_to_new_format(assembly_hash)
          new_format = []
          if components = assembly_hash['components']
            new_format << convert_components_to_new_form(components)
          end

          if nodes = assembly_hash['nodes']
            nodes.each do |name, content|
              new_format << { "node[#{name}]" => convert_node_to_new_format(content) }
            end
          end
          new_format.flatten
        end

        def convert_node_to_new_format(content)
          new_node = []
          if content.is_a?(Hash)
            if attributes = content['attributes']
              new_node << { 'attributes' => attributes }
            end
            if components = content['components']
              new_node << convert_components_to_new_form(components)
            end
          else
            return content
          end
          new_node.flatten
        end

        def convert_components_to_new_form(components)
          new_components = []
          components.each do |component|
            if component.is_a?(String)
              new_components << "component[#{component}]"
            else
              name = component.keys.first
              value = component[name]
              new_components << { "component[#{name}]" => value }
            end
          end
          new_components.flatten
        end

      end
    end
  end
end
