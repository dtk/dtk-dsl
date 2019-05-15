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
    class Parser < ServiceAndComponentInfo::Parser
      require_relative('parser/module_refs')
      require_relative('parser/component_module')
      require_relative('parser/service_module')
      require_relative('parser/kubernetes_crd')
      require_relative('parser/kubernetes_crd_instance')

      private
      def update_output_hash__dependencies?
        if component_dsl_canonical_hash = input_file_hash?(:module)
          if dependencies = component_dsl_canonical_hash['dependencies']
            add_dependencies_to_output_hash!(dependencies)
            output_hash
          end
        end
      end

      def add_dependencies_to_output_hash!(dependencies)
      end
    end
  end
end
