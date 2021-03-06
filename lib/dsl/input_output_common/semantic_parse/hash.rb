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
  class InputOutputCommon
    module SemanticParse
      class Hash < Canonical::Hash
        include Mixin
        # opts can have keys
        #  :qualified_key
        def initialize(parent_class, opts = {})
          super(parent_class)
          initialize_semantic_parse(opts)      
        end

        # The method skip_for_generation? can be overwritten
        def skip_for_generation?
          false
        end
      end
    end
  end
end

