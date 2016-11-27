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
      class Dependencies < self
        def update_output_hash?
          if module_refs_input_files = input_files?(:module_refs)
            existing_module_refs = output_hash['dependencies'] || {}
            merge_in_new_module_refs!(existing_module_refs, module_refs_input_files.content_hash)
          end
        end
        
        private
        
        def merge_in_new_module_refs!(module_refs_hash, input_module_refs_hash)
          ndx_existing_modules = ndx_existing_modules(module_refs_hash)
          component_modules(input_module_refs_hash).each do |module_info|
            module_info.raise_error_if_conflicts(ndx_existing_modules)
            module_refs_hash.merge!(module_info.combined_module_form)
          end
        end
        
        
        # indexed by module_name
        def ndx_existing_modules(module_refs_hash)
          module_refs_hash.inject({}) do |h, (namespace_name, version)|
            namespace, name = namespace_name.split(ModuleInfo::NAMESPACE_NAME_DELIM)
            h.merge(name => ModuleInfo.new(namespace, name,  version))
          end
        end

        def component_modules(input_module_refs_hash)
          (input_module_refs_hash['component_modules'] || {}).inject([]) do |a, (name, info)|
            a + ModuleInfo.new(info['namespace'], name, version)
          end
        end


        class ModuleInfo
          attr_reader :namespace, :module_name, :version
          def initialize(namespace, module_name, version)
            @namespace = namespace
            @module_name = module_name
            @version     = version || 'master'
          end
          
          NAMESPACE_NAME_DELIM = '/'
          
          def combined_module_form
            "#{@namespace}#{NAMESPACE_NAME_DELIM}#{@name}" => @version
          end
          
          def raise_error_if_conflict(ndx_existing_modules)
            # TODO:: stub; raise Error::Usage
          end
        end
          
      end
    end
  end
end
