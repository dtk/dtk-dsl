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
class DTK::DSL::FileParser
  class Output
    class Array < InputOutputCommon::Array 
      def reify(obj)
        if obj.kind_of?(self.class)
          obj
        elsif obj.kind_of?(::Array)
          inject(self.class.new) { |a, el| a << reify(el) }
        elsif obj.kind_of?(::Hash)
          Output::Hash.new(obj)
        else
          obj
        end
      end
    end
  end
end


