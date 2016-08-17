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
      class Set < self
        attr_accessor :added, :deleted, :modified
        def initialize(added, deleted, modified)
          super()
          @added    = added || []
          @deleted  = deleted || []
          @modified = modified || []
        end
        
        def empty?
          @added.empty? and @deleted.empty? and @modified.empty?
        end
        
        def +(diff_set)
          new(@added + diff_set.added, @deleted + diff_set.deleted, @modified + diff_set.modified) 
        end
        
        
        # The arguments gen_hash is caonical hash produced by generation and parse_hash is canonical hash produced by parse with values being of type object_type
        def self.between_hashes(object_type, gen_hash, parse_hash)
          between_arrays_or_hashes(:hash, object_type, gen_hash, parse_hash)
        end
        
        # The arguments gen_array is caonical array produced by generation and parse_array is canonical array produced by parse with values being of type object_type
        def self.between_arrays(object_type, gen_array, parse_array)
          ndx_gen_array = (gen_array || []).inject({}) { |h, gen_object| h.merge(gen_object.diff_key => gen_object) }
          ndx_parse_array = (parse_array || []).inject({}) { |h, parse_object| h.merge(parse_object.diff_key => parse_object) }
          between_arrays_or_hashes(:array, object_type, ndx_gen_array, ndx_parse_array) 
        end
        
        private
        
        def self.between_arrays_or_hashes(array_or_hash, object_type, gen_hash, parse_hash)
          added    = []
          deleted  = []
          modified = []
          
          gen_hash   ||= {}
          parse_hash ||= {}
          
          parse_hash.each do |key, parse_object|
            if gen_hash.has_key?(key)
              if diff = gen_hash[key].diff?(parse_object, key)
                modified << diff
              end
            else
              added << parse_object
              # TODO: think we need key somewhere
              # added.merge!(key => parse_object)
            end
          end
          
          gen_hash.each do |key, gen_object|
            # TODO: think we need key somewhere
            #deleted.merge!(key => gen_object) unless parse_hash.has_key?(key)
            deleted << gen_object unless parse_hash.has_key?(key)
          end
          
          case array_or_hash
          when :hash
            new(added, deleted, modified)
          when :array
            new(added.values, deleted.values, modified.values)
          end
        end
        
      end
    end
  end
end
