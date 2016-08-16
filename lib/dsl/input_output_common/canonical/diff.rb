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
      require_relative('diff/array')
      require_relative('diff/hash')

      def initialize(object_type)
        @type = object_type
      end

      # The arguments gen_hash is caonical hash produced by generation and parse_hash is caonical hash produced by parse with values being of type object_type
      def self.objects_in_hash?(object_type, gen_hash, parse_hash)
        objects_in_array_or_hash?(:hash, object_type, gen_hash, parse_hash)
      end

      # The arguments array1 and array2 are canonical arrays with values being of type object_type
      def self.objects_in_array?(object_type, array1, array2)
        ndx_array1 = array1.inject({}) { |h, gen_object| h.merge(gen_object.diff_key => gen_object) }
        ndx_array2 = array2.inject({}) { |h, parse_object| h.merge(parse_object.diff_key => parse_object) }
        objects_in_array_or_hash?(:array, ndx_array1, ndx_array2) 
      end

      def self.base_new(gen_object, parse_object)
        diff_class::Base.new(gen_object, parse_object)
      end

      private

      def self.objects_in_array_or_hash?(array_or_hash, object_type, gen_hash, parse_hash)
        added    = {}
        deleted  = {}
        modified = {}
        parse_hash.each do |key, parse_object|
          if gen_hash.has_key?(key)
            if diff = gen_hash[key].diff?(parse_object)
              modified.merge!(key => diff)
            else
              added.merge!(key => parse_object)
            end
          end
        end
        
        gen_hash.each do |key, gen_object|
          deleted.merge!(key => gen_object) unless parse_hash.has_key?(key)
        end

        unless added.empty? and deleted.empty? and modified.empty?
          case array_or_hash
          when :hash
            diff_class::Hash.new(object_type, added, deleted, modified)
            when :array
            diff_class::Array.new(object_type, added.values, deleted.values, modified.values)
          end
        end
      end

      def self.diff_class
        InputOutputCommon::Canonical::Diff
      end
    end
  end
end
