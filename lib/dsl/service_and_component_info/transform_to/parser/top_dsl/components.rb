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
    class TopDSL
      class Components < self
        def update_output_hash?
          if component_dsl_input_file = input_files?(:component_dsl_file)
            component_dsl_input_hash = component_dsl_input_file.content_hash
            if component_defs = component_dsl_input_hash['components']
              output_hash['component_defs'] = component_defs
            end
          end
        end

      end
    end
  end
end
