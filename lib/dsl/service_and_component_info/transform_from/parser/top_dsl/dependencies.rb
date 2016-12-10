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
  class ServiceAndComponentInfo
    class TransformFrom::Parser::TopDSL
      class Dependencies < self
        def update_output_hash?
          if module_refs_input_file = input_files?(:module_refs)
            module_refs_input_hash = module_refs_input_file.content_hash
            unless module_refs_input_hash.empty?
              existing_module_refs = output_hash['dependencies'] ||= {}
              merge_in_new_module_refs!(existing_module_refs, module_refs_input_hash)
            end
          end
        end
        
        private
        
        def merge_in_new_module_refs!(module_refs_hash, input_module_refs_hash)
          ndx_existing_modules = ndx_existing_modules(module_refs_hash)
          component_module_refs(input_module_refs_hash).each do |module_ref|
            raise_error_if_conflict(module_ref, ndx_existing_modules)
            module_refs_hash.merge!(combined_module_form(module_ref))
          end
        end

        def component_module_refs(input_module_refs_hash)
          (input_module_refs_hash['component_modules'] || {}).inject([]) do |a, (name, info)|
            a + [ModuleRef.new(info['namespace'], name, info['version'])]
          end
        end

        
        NAMESPACE_NAME_DELIM = '/'
        # indexed by module_name
        def ndx_existing_modules(module_refs_hash)
          module_refs_hash.inject({}) do |h, (namespace_name, version)|
            namespace, name = namespace_name.split(NAMESPACE_NAME_DELIM)
            h.merge(name => ModuleRef.new(namespace, name,  version))
          end
        end

        def combined_module_form(module_ref)
          { "#{module_ref.namespace}#{NAMESPACE_NAME_DELIM}#{module_ref.module_name}" => module_ref.version }
        end
          
        def raise_error_if_conflict(module_ref, ndx_existing_modules)
          if matching_module_ref = ndx_existing_modules[@module_name]
            fail Error::Usage, conflict_error_msg(module_ref, matching_module_ref) unless module_ref.match?(matching_module_ref)
          end
        end


        def conflict_error_msg(module_ref, matching_module_ref)
          "Conflicting versions of module '#{module_ref.module_name}': '#{module_ref.print_form}' vs '#{matching_module_ref.print_form}'"
        end

      end
    end
  end
end
