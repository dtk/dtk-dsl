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
      class Component < self
        def compute_outputs!
          require 'debugger'
          Debugger.start
          debugger
          path = top_level_dsl_path
          update_or_add_output_hash!(path, top_dsl_file_hash_content!(output_file_hash(path)))
        end
        
        private
        
        def info_type
          :component_info
        end

        def top_dsl_file_hash_content!(output_hash)
          top_dsl_parser::ModuleInfo.update_output_hash?(output_hash, self) 
          top_dsl_parser::Dependencies.update_output_hash?(output_hash, self)
          top_dsl_parser::Components.update_output_hash?(output_hash, self)
          output_hash
        end
      end
    end
  end
end
