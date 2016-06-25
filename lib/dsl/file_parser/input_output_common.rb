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
  class FileParser
    class InputOutputCommon
      require_relative('input_output_common/hash')
      require_relative('input_output_common/array')

      private
      
      def self.obj_type(obj)
        if obj.kind_of?(::Hash)
          :hash
        elsif obj.kind_of?(::Array)
          :array
        elsif obj.kind_of?(::String)
          :string
        else
          raise Error, "Unexpected type '#{obj.class}'"
        end
      end
        
      def self.create_aux(type, obj = nil)
        case type
        when :hash 
          # if obj.class not ::Hash then reified already
          (obj.nil? or obj.class == ::Hash) ? self::Hash.new(obj) : obj
        when :array 
          # if obj.class not ::Array then reified already
          (obj.nil? or obj.class == ::Array) ? self::Array.new(obj) : obj
        when :string 
          # no reification for string
          ::String.new(obj || '') 
        else 
          raise Error, "Unexpected type '#{type}'"
        end
      end
    end
  end
end
