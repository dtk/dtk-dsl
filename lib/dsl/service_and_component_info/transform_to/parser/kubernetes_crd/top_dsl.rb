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
    module KubernetesCrd
      class TopDSL < Parser
        def update_output_hash?
          if module_dsl_canonical_hash = input_file_hash?(:module)
            add_base_crd_info_to_output_hash!
            if component_defs = module_dsl_canonical_hash.val(:ComponentDefs)
              add_components_to_output_hash!(component_defs)
              output_hash
            end
          end
        end

        private

        API_VERSION = 'apiextensions.k8s.io/v1beta1'
        KIND = 'CustomResourceDefinition'
        GROUP = 'component.dtk.io'
        VALIDATION_SCHEMA = :openAPIV3Schema
        def add_base_crd_info_to_output_hash!
          output_hash[:apiVersion] = API_VERSION
          output_hash[:kind] = KIND
          output_hash[:metadata] = {}
          output_hash[:spec] = {}
        end

        def add_components_to_output_hash!(component_defs)
          # used to pluralize component names
          require 'active_support/inflector'

          component = component_defs.keys.first
          component_plural = component.pluralize
          component_content = component_defs[component]

          output_hash[:metadata].merge!(name: "#{component_plural}.#{GROUP}", resourceVersion: nil)
          output_hash[:spec].merge!(group: GROUP, version: 'v1alpha1', scope: 'Namespaced')
          
          output_hash[:spec].merge!({
            names: {
              singular: component,
              plural: component_plural,
              kind: component.capitalize
            }
          })

          output_hash[:spec].merge!({
            validation: {
              "#{VALIDATION_SCHEMA}": {
                required: ['spec'],
                properties: {
                  spec: {
                    required: find_required(component_content['attributes']),
                    properties: find_attributes(component_content['attributes'])
                  }
                }
              }
            }
          })
        end

        private

        def find_required(attributes)
          return [] unless attributes
          ret = []
          attributes.each do |name, value|
            if value[:required]
              ret << name unless name.to_s.eql?('name')
            end
          end
          ret
        end

        def find_attributes(attributes)
          fail 'Unexpected that attributes are empty' unless attributes
          ret = {}
          attributes.each do |name, value|
            next if name.to_s.eql?('name')

            ret[name] = {}
            ret[name].merge!(type: ret_type(value[:type])) if value[:type]

            if default = value[:default]
              ret[name][:example] ||= {}
              ret[name][:example].merge!(default: format_default(default))
            end

            if dynamic = value[:dynamic]
              ret[name][:example] ||= {}
              ret[name][:example].merge!(dynamic: dynamic)
            end

            if input = value[:input]
              ret[name][:example] ||= {}
              ret[name][:example].merge!(input: input)
            end
          end

          ret
        end

        def ret_type(type)
          return type unless type.to_s.eql?('hash') || type.to_s.eql?('array')
          return 'object'
        end

        def format_default(default)
          if default.is_a?(Hash)
            key = default.keys.first
            return "#{key}: #{default[key]}"
          end
        end
      end
    end
  end
end; end
