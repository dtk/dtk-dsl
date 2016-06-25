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
module DTK::DSL; class FileParser
  class Template
    class V1 < self
      require_relative('v1/common_module_summary')
      # common_module_summar must be before common_module
      require_relative('v1/common_module')
      require_relative('v1/module_ref')
      require_relative('v1/dependent_modules')
      require_relative('v1/assemblies')
      require_relative('v1/assembly')

      VERSION = 1
      def template_version
        VERSION
      end
    end
  end
end; end

