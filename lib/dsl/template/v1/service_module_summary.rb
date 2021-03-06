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
class DTK::DSL::Template
  class V1
    class ServiceModuleSummary < self
      module Constant
        module Variations
        end
        extend ClassMixin::Constant

        DSLVersion = 'dsl_version'
        Module = 'module'
        Variations::Module = ['module', 'module_name', 'name'] 
      end

      def parse!
        set :DSLVersion, input_key_value(:DSLVersion)
        set :Name, input_key_value(:Module)
      end
    end
  end
end
