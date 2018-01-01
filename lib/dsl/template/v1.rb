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
  class Template
    class V1 < self
      require_relative('v1/service_module_summary')
      require_relative('v1/common_module_summary')
      # common_module_summary must be before common_module
      require_relative('v1/common_module')
      require_relative('v1/service_instance')
      require_relative('v1/module_refs_lock')
      require_relative('v1/module_ref')
      require_relative('v1/component_def')
      require_relative('v1/assembly')
      require_relative('v1/attribute')
      require_relative('v1/component_link')
      # attribute must go before node_attribute
      require_relative('v1/node_attribute')
      require_relative('v1/node')
      require_relative('v1/component')
      require_relative('v1/workflow')
      require_relative('v1/dependency')

      VERSION = 1
      def template_version
        VERSION
      end

      def dsl_version
        '1.0.0'
      end
    end
  end
end

