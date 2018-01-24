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
    class CommonModuleSummary < self
      module Constant
        module Variations
        end
        extend ClassMixin::Constant

        DSLVersion = 'dsl_version'
        ModuleVersion = 'version'
        DependentModules = 'dependencies'

        Module = 'module'
        Variations::Module = ['module', 'module_name'] 
      end

      def parse!
        set :DSLVersion, input_key_value?(:DSLVersion) || dsl_version
        set :ModuleVersion, input_key_value(:ModuleVersion)
        merge parse_child(:module_ref, input_key_value(:Module), :parent_key => Constant::Module)
        # TODO: DTK-3366: depent modules now in module refs lock
        # set? :DependentModules, parse_child_elements?(:dependency, :DependentModules)
      end
    end
  end
end
