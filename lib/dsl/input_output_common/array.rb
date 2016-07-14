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
    class Array < ::Array
      def initialize(parent_class, array = nil)
        array.each { |el| self << reify(parent_class, el) } if array
      end

      private

      def reify(parent_class, obj)
        if obj.kind_of?(self.class)
          obj
        elsif obj.kind_of?(::Array)
          inject(self.class.new(parent_class)) { |a, el| a << reify(parent_class, el) }
        elsif obj.kind_of?(::Hash)
          parent_class::Hash.new(parent_class, obj)
        else
          obj
        end
      end

    end
  end
end


