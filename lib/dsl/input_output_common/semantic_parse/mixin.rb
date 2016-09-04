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
      module Mixin
        # opts can have keys
        #  :qualified_key
        def initialize_semantic_parse(opts = {})
          @qualified_key = opts[:qualified_key]
        end
        private :initialize_semantic_parse

        def qualified_key
          @qualified_key || fail(Error, "Unexepcetd that @qualified_key is nil")
        end

        def name 
          qualified_key.relative_distinguished_name
        end

        def qualified_name
          qualified_key.print_form
        end
      end
    end
  end
end

