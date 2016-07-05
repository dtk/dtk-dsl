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
    module OutputClassMixin
      # opts can have keys
      #  :output_type
      #  :input
      # In both cases an empty object is created using :output_type or type of :input to determine its type
      def create(opts = {})
        unless opts[:output_type] or opts[:input]
          raise Error, "opts must have one of the keys :output_type or :input"
        end
        obj_type = opts[:output_type] || obj_type(opts[:input])
        create_aux(obj_type)
      end
    end
  end
end
