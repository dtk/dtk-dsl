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
  class Template
    module Diff
      module Mixin
        # Main template-specfic diff instance method call; Concrete classes overwrite this
        def diff?(_object2)
          raise Error::NoMethodForConcreteClass.new(self.class)
        end

        # Needed by any object that can be grouped as an array (as opposed to a hash)
        def diff_key
          raise Error::NoMethodForConcreteClass.new(self.class)
        end
      end
      
      module ClassMixin
        # Main template-specfic diff class method call; Concrete classes overwrite this
        def compute_diff_object?(_objects1, _objects2)
          raise Error::NoMethodForConcreteClass.new(self)
        end
      end
 
      # The arguments hash1 and hash2 are canonical hashes with values being of type object_type
      def self.objects_in_hash?(object_type, hash1, hash2)
        objects_in_array_or_hash?(:hash, object_type, hash1, hash2)
      end

      # The arguments array1 and array2 are canonical arrays with values being of type object_type
      def self.objects_in_array?(object_type, array1, array2)
        ndx_array1 = array1.inject({}) { |h, object1| h.merge(object1.diff_key => object1) }
        ndx_array2 = array2.inject({}) { |h, object2| h.merge(object2.diff_key => object2) }
        objects_in_array_or_hash?(:array, ndx_array1, ndx_array2) 
      end

      def self.base_new(object1, object2)
        diff_class::Base.new(object1, object2)
      end

      private

      def self.objects_in_array_or_hash?(array_or_hash, object_type, hash1, hash2)
        added    = {}
        deleted  = {}
        modified = {}
        hash2.each do |key, object2|
          if hash1.has_key?(key)
            if diff = diff?(hash1[key], object2)
              modified.merge!(key => diff)
            else
              added.merge!(key => object2)
            end
          end
        end
        
        hash1.each do |key, object1|
          deleted.merge!(key => object1) unless hash2.has_key?(key)
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
