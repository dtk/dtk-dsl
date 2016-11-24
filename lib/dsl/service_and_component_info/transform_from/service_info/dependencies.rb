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
    class ServiceInfo 
      class Dependencies < Base
        def hash_content?
          if module_refs_input_files = input_files?(:module_refs)
            module_refs_hash = module_refs_input_files.content_hash
            dependencies = {}
            if cmp_dependencies = module_refs_hash['component_modules']
              cmp_dependencies.each_pair do |name, namespace_h|
                dependencies.merge!({ "#{namespace_h['namespace']}/#{name}" => namespace_h['version']||'master' })
              end
            end
            dependencies
          end
        end

      end
    end
  end
end
