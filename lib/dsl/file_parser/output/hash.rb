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
    class Hash < InputOutputCommon::Hash
      require_relative('hash/key')

      def reify(obj)
        if obj.kind_of?(self.class)
          obj
        elsif obj.kind_of?(::Hash)
          obj.inject(self.class.new) { |h, (k, v)| h.merge(k => reify(v)) }
        elsif obj.kind_of?(::Array)
          Output::Array.new(obj)
        else
          obj
        end
      end

      def set(output_key, val)
        self[canonical_key_form_from_output_key(output_key)] = val
      end

      # value at index output_key
      def val(output_key)
        ret = nil
        possible_key_forms_from_output_key(output_key).each do |internal_index|
          return self[internal_index] if has_key?(internal_index)
        end
        ret
      end

      # required that value at index is non nil
      def req(output_key)
        ret = val(output_key)
        if ret.nil?
          raise Error, "Unexpected nil value for output key '#{output_key}'"
        else
          ret
        end
      end
      
      private

      def canonical_key_form_from_output_key(output_key)
        Key.index(output_key)
      end

      # TODO: after converting so that all accessed keys are in canonical_key_form
      # then can have do away with this method
      def possible_key_forms_from_output_key(output_key)
        key = canonical_key_form_from_output_key(output_key)
        [key.to_s, key.to_sym]
      end
    end
  end
end
