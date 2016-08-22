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
        # args will have form
        # [added, deleted, modified]
        # or
        # [diff_set]
        def initialize(*args)
          super()
          if args.size == 1 and args[0].kind_of?(Diff::Set)
            diff_set = args[0]
            @added    = diff_set.added
            @deleted  = diff_set.deleted
            @modified = diff_set.modified
          elsif args.size == 3 and ! args.find { |arg| ! (arg.kind_of?(::Array) or arg.nil?) }
            @added    = args[0] || []
            @deleted  = args[1] || []
            @modified = args[2] || []
          else
            raise Error, "The params args has unexepcetd form"
          end
          @key = nil
        end
        private :initialize
        attr_accessor :added, :deleted, :modified
        attr_writer :key
        def key
          @key || raise(Error, "Unexpected that @key is nil")
        end

        # The arguments gen_hash is canonical hash produced by generation and parse_hash is canonical hash produced by parse with values being elements of same type
        def self.between_hashes(gen_hash, parse_hash)
          between_arrays_or_hashes(:hash, gen_hash, parse_hash)
        end
        
        # The arguments gen_array is canonical array produced by generation and parse_array is canonical array produced by parse with values being elements of same type
        def self.between_arrays(gen_array, parse_array)
          ndx_gen_array = (gen_array || []).inject({}) { |h, gen_object| h.merge(gen_object.diff_key => gen_object) }
          ndx_parse_array = (parse_array || []).inject({}) { |h, parse_object| h.merge(parse_object.diff_key => parse_object) }
          between_arrays_or_hashes(:array, ndx_gen_array, ndx_parse_array) 
        end

        # opts can have keys
        #   :key
        def self.aggregate?(diff_sets, opts = {})
          ret = nil
          diff_sets = diff_sets.kind_of?(::Array) ? diff_sets : [diff_sets]
          diff_sets.each do |diff_set|
            next if diff_set.empty?
            if ret
              ret.add!(diff_set)
            else
              ret = new(diff_set)
            end
          end
          ret.key = opts[:key] if ret
          ret
        end
        
        def empty?
          @added.empty? and @deleted.empty? and @modified.empty?
        end
        
        def add!(diff_set)
          @added    += diff_set.added
          @deleted  += diff_set.deleted
          @modified += diff_set.modified
        end
        
        private
        
        def self.between_arrays_or_hashes(array_or_hash, gen_hash, parse_hash)
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
