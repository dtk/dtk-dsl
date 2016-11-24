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
  class ServiceAndComponentInfo::TransformFrom
    class ServiceInfo::Assemblies 
      module NodeBindings
        def self.add_node_properties!(assembly_content, node_bindings) 
          nodes = assembly_content['nodes'] || []
          return if nodes.empty?
        
          node_bindings.each do |node, node_binding|
            if node_content = nodes[node]
              process_node_content!(node_content, node_binding) 
            end
          end
        end

        private

        def self.process_node_content!(node_content, node_binding)
          components  = node_content['components']
          components  = components.is_a?(Array) ? components : [components]
          image, size = ec2_properties_from_node_binding(node_binding)
          new_attrs   = { 'image' => image, 'size' => size }

          if index = include_node_property_component?(components)
            ec2_properties = components[index]
            if ec2_properties.is_a?(::Hash)
              if attributes = ec2_properties.values.first['attributes']
                attributes['image'] ||= image
                attributes['size'] ||= size
              else
                ec2_properties.merge!('attributes' => new_attrs)
              end
            else
              components[index] = { ec2_properties => { 'attributes' => new_attrs } }
            end
          elsif node_attributes = node_content['attributes']
            node_attributes['image'] ||= image 
            node_attributes['size'] ||= size 
          else
            node_content['attributes'] = new_attrs
          end
        end

      end
      
      private

      def self.ec2_properties_from_node_binding(node_binding)
        image, size = node_binding.split('-')
        [image, size]
      end

      def self.include_node_property_component?(components)
        property_component = 'ec2::properties'
        components.each do |component|
          if component.is_a?(Hash)
            return components.index(component) if component.keys.first.eql?(property_component)
          else
            return components.index(component) if component.eql?(property_component)
          end
        end
        false
      end

    end
  end
end
