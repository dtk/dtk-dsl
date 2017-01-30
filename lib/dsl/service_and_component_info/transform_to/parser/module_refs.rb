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
 class ServiceAndComponentInfo::TransformTo::Parser
   class ModuleRefs < self
      def update_output_hash?
        if module_dsl_canonical_hash = input_file_hash?(:module)
          if dependencies = module_dsl_canonical_hash.val(:DependentModules)
            add_dependencies_to_output_hash!(dependencies)
            output_hash
          end
        end
      end
      
      private

      def add_dependencies_to_output_hash!(dependencies_canonical_array)
        component_modules = dependencies_canonical_array.inject({}) do |h, dependency_canonical_hash|
          module_name = dependency_canonical_hash.val(:ModuleName)
          namespace   = dependency_canonical_hash.val(:Namespace)
          version     = version?(dependency_canonical_hash)

          module_info = { 'namespace' => namespace }
          module_info.merge!('version' => version) if version
          h.merge(module_name => module_info)
        end

        output_hash.merge!('component_modules' => component_modules) unless component_modules.empty?
      end

      def version?(dependency_canonical_hash)
        if version = dependency_canonical_hash.val(:ModuleVersion)
          version == 'master' ? nil : version
        end
      end

    end
  end
end
