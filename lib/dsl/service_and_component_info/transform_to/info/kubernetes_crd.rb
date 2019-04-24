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
      class KubernetesCrd < self
        def compute_outputs!
          set_top_level_dsl_output_hash!
        end
        
        private
        
        def info_type
          :kubernetes_crd
        end

        def set_top_level_dsl_output_hash!
          path   = ComponentModulePath.top_level_dsl
          parser = component_module_dsl_parser::TopDSL
          set_output_hash?(parser, path)
        end

        def set_output_hash?(parser, path)
          output_hash = output_file_hash(path)
          if parser.update_output_hash?(output_hash, self) # This conditionally updates output_hash
            update_or_add_output_hash!(path, output_hash)
          end
        end

        def component_module_dsl_parser
          @component_module_dsl_parser ||= Parser::KubernetesCrd
        end
        
        module ComponentModulePath
          TOP_LEVEL_DSL = 'app_component_crd.yaml'
          MODULE_REFS = 'module_refs.yaml'
          def self.top_level_dsl
            TOP_LEVEL_DSL
          end
          def self.module_refs
            MODULE_REFS
          end
        end
        
      end
    end
  end
end
