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
  class InputOutputCommon::Canonical
    class Diff
      require_relative('diff/base')
      require_relative('diff/set')

      def self.diff?(key, current_val, new_val)
        bass_class.diff?(key, current_val, new_val)
      end

      # The arguments gen_hash is canonical hash produced by generation and parse_hash is canonical hash produced by parse with values being elements of same type
      def self.between_hashes(gen_hash, parse_hash)
        set_class.between_hashes(gen_hash, parse_hash)
      end
      
      # The arguments gen_array is canonical array produced by generation and parse_array is canonical array produced by parse with values being elements of same type
      def self.between_arrays(gen_array, parse_array)
        set_class.between_arrays(gen_array, parse_array)
      end

      private

      def self.bass_class
        kind_of?(Base) ? self : Base
      end

      def self.set_class
        kind_of?(Set) ? self : Set
      end

    end
  end
end
