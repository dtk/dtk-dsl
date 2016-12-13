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
    module ComponentModule
      class TopDSL < Parser
        def update_output_hash?
          if module_dsl_input_file = input_files?(:module)
            module_dsl_canonical_hash = module_dsl_input_file.content_hash
            if component_defs = module_dsl_canonical_hash.val(:ComponentDefs)
              add_module_info_to_output_hash!
              add_components_to_output_hash!(component_defs)
              output_hash
            end
          end
        end
        
        private
        
        COMPONENT_MODULE_DSL_VERSION = '1.0.0'
        def add_module_info_to_output_hash!
          output_hash['module']      = info_object.module_ref.module_name
          output_hash['dsl_version'] = COMPONENT_MODULE_DSL_VERSION
        end
        
        def add_components_to_output_hash!(component_defs)
          output_hash['components'] = component_defs
        end
        
      end
    end
  end
end; end
