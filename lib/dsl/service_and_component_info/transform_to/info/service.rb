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
    class Info
      class Service < self
        def compute_outputs!
          set_top_level_dsl_output_hash!
          set_module_refs_output_hash!
        end

        private

        def info_type
          :service_info
        end

        def set_top_level_dsl_output_hash!
          parser = service_module_dsl_parser::TopDSL
          set_output_hash?(parser)
        end

        def set_module_refs_output_hash!
          path        = ServiceModulePath.module_refs
          parser      = service_module_dsl_parser::ModuleRefs
          output_hash = output_file_hash(path)
          update_or_add_output_hash!(path, output_hash) if parser.update_output_hash?(output_hash, self)
        end

        def set_output_hash?(parser)
          output_hash = {}
          if parser.update_output_hash?(output_hash, self)
            if assemblies = output_hash['assemblies'] || output_hash[:assemblies]
              assemblies.each { |assembly| update_or_add_output_hash!(ServiceModulePath.top_level_dsl(assembly['name']||assembly[:name]), assembly) }
            end
          end
        end

        def service_module_dsl_parser
          @service_module_dsl_parser ||= Parser::ServiceModule
        end

        module ServiceModulePath
          TOP_LEVEL_DSL = 'dtk.assembly.yaml'
          MODULE_REFS = 'module_refs.yaml'
          def self.top_level_dsl(assembly_name)
            "assemblies/#{assembly_name}.#{TOP_LEVEL_DSL}"
          end
          def self.module_refs
            MODULE_REFS
          end
        end

      end
    end
  end
end
