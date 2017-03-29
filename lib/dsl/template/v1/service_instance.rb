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
    class ServiceInstance < self
      module Constant
        module Variations
        end
        extend ClassMixin::Constant

        DSLVersion = 'dsl_version'
        Name = 'name'
        Variations::Name = ['name', 'service_name'] 
        DependentModules = 'dependencies'
      end

      def yaml_object_type
        :array
      end

      ### For parsing
      def parse!
        remove_processed_keys_from_input_hash! do
          set :DSLVersion, input_key_value(:DSLVersion)
          set :Name, input_key_value(:DSLVersion)
          set? :DependentModules, input_key_value?(:DependentModules)
        end
        merge parse_child(:assembly, input_hash)
      end

      ### For generation
      def generate!
        add({'dsl_version' => req(:DSLVersion)})
        add({'name' => req(:Name)})

        if dependent_modules = val(:DependentModules)
          add('dependencies' => dependent_modules)
        end

        concat(generate_child(:assembly, req(:Assembly)) || [])
      end

    end
  end
end
