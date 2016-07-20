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
  class FileGenerator::ContentInput
    module Tags
      #####
      # In this module a 'tag_type' subsumes a tag and consitutes an element in BASE_LEVEL_TAGS or one its prefixes
      #
      DELIMITER = '__'
      BASE_LEVEL_TAGS = 
        [:asserted, 
         :derived__default, 
         :derived__propagated, 
         :hidden
        ]
      
      def self.matches_tag_type?(tag_type, tag)
        tag_type_split = split(tag_type)
        tag_split = split(tag)
        if tag_split.size >= tag_type_split.size
          tag_split.each_with_index do |tag_part, i|
            return nil unless tag_part == tag_type_split[i]
          end
          true
        end
      end
      
      def self.valid?(tag_type)
        valid_tag_types.include?(tag_type)
      end
      
      def self.raise_error_if_invalid(tag_types)
        tag_types = [tag_types] unless tag_types.kind_of?(::Array)
        bad_tag_types = tag_types.select { |tag| !valid?(tag)}
        unless bad_tag_types.empty?
          err_msg = bad_tag_types.size == 1 ? "Invalid tag '#{bad_tag_types.first}'" : "Invalid tag_types: #{bad_tag_types.join(', ')}"
          raise Error, err_msg
        end
      end
      
      private
      
      def self.valid_tag_types
        @valid_tag_tag_types ||= compute_valid_tag_types
      end
      
      # Iterates over BASE_LEVEL_TAGS and puts in prefixes
      def self.compute_valid_tag_types
        ret = []
        BASE_LEVEL_TAGS.each do |tag|
          tag_split = split(tag)
          until tag_split.empty?
            ret << join(tag_split)
            tag_split.pop
          end
        end
        ret.uniq
      end 
      
      def self.split(t)
        t.to_s.split(DELIMITER).map(&:to_sym)
      end
  
      def self.join(t_split)
        t_split.map(&:to_s).join(DELIMITER).to_sym
      end

      module Mixin
        attr_reader :tags
        
        def initialize_tags!
          @tags = []
        end
        private :initialize_tags!
        
        def add_tags!(new_tags)
          Tags.raise_error_if_invalid(new_tags)
          new_tags = [new_tags] unless new_tags.kind_of?(::Array)
          @tags += new_tags
          @tags.uniq!
          self
        end

        def add_tags?(new_tags)
          add_tags!(new_tags) unless new_tags.nil? or new_tags.empty?
        end

        def matches_tag_type?(tag_type)
          Tags.raise_error_if_invalid(tag_type)
          !! @tags.find { |tag| Tags.matches_tag_type?(tag_type, tag) }
        end

        def add_tags_to_obj?(obj, new_tags) 
          obj.add_tags!(new_tags) if obj.respond_to?(:add_tags!)
          obj
        end
      
        def obj_has_tag_type?(obj, tag_type)  
          if obj.respond_to?(:matches_tag_type?)
            obj.matches_tag_type?(tag_type)
          else
            # vacuously succeeds
            true
          end
        end

      end
    end
  end
end

