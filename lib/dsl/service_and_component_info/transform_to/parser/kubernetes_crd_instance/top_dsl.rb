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
module DTK::DSL; class ServiceAndComponentInfo::TransformTo
  class Parser
    module KubernetesCrdInstance
      class TopDSL < Parser
        def update_output_hash?
          if @module_dsl_canonical_hash = input_file_hash?(:module)
            add_base_crd_info_to_output_hash!
            if component_defs = @module_dsl_canonical_hash.val(:ComponentDefs)
              add_components_to_output_hash!(component_defs)
              output_hash
            end
          end
        end

        private

        API_VERSION = 'dtk.io/v1alpha1'
        KIND = 'Componentdef'
        def add_base_crd_info_to_output_hash!
          output_hash[:apiVersion] = API_VERSION
          output_hash[:kind] = KIND
          output_hash[:metadata] = {}
          output_hash[:spec] = {
            module_name: @module_dsl_canonical_hash.val(:ModuleName),
            version: @module_dsl_canonical_hash.val(:Version)
          }
        end

        def add_components_to_output_hash!(component_defs)
          component = component_defs.keys.first
          component_content = component_defs[component]

          output_hash[:metadata].merge!(name: component, namespace: component_content['namespace']||'default')

          if attributes = component_content['attributes']
            output_hash[:spec].merge!({
              attributes: format_attributes(attributes)
            })
          end

          if actions = component_content['actions']
            output_hash[:spec].merge!({
              actions: actions
            })
          end
        end

        private

        def format_attributes(attributes)
          attrs = []
          attributes.each do |name, attribute|
            attribute.merge!(items: []) if attribute['type'].eql?('array')
            new_res = {name: name}.merge(attribute)
            attrs << new_res
          end
          attrs
        end
      end
    end
  end
end; end
