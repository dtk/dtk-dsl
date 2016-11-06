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
    class Tag
      require_relative('tag/simple')
      require_relative('tag/assignment')

      attr_reader :name
      def initialize(tag_name)
        @name = tag_name
      end
      private :initialize

      def self.create(tag_input)
        tag = 
          if tag_input.kind_of?(::String) or tag_input.kind_of?(::Symbol)
            Simple.new(tag_input.to_sym)
          elsif tag_input.kind_of?(::Hash) and tag_input.size == 1
            tag_name  = tag_input.keys.first
            if tag_name.kind_of?(::String) or tag_name.kind_of?(::Symbol)
              tag_value = tag_input.values.first
              Assignment.new(tag_name.to_sym, tag_value)
            end
          end
        raise Error, "Invalid form for a tag: #{tag_input.inspect}"  unless tag
        raise Error, "Invalid tag name '#{tag.name}'" unless  tag.valid_tag_name?
        tag
      end
      private_class_method :create

      def self.add_tags!(tags, new_tags_input)
        new_tags_input.each do |new_tag_input|
          new_tag = create(new_tag_input)
          new_tag_name = new_tag.name
          unless match = tags.find { |tag| tag.name == new_tag_name }
            tags << new_tag
          else
            raise_error_if_conflicting_tags(match, new_tag)
          end
        end
        tags
      end

      def self.matches_tag_type?(tag_type, tag)
        tag_type_split = split(tag_type)
        tag_split = split(tag.name)
        if tag_split.size >= tag_type_split.size
          tag_type_split.each_with_index do |tag_type_part, i|
            return nil unless tag_type_part == tag_split[i]
          end
          true
        end
      end

      #####
      # In this module a 'tag_type' subsumes a tag and consitutes an element in BASE_LEVEL_TAGS or one its prefixes
      #
      DELIMITER = '__'
      BASE_LEVEL_TAGS = 
        [:desired__asserted, 
         :desired__derived__default, 
         :desired__derived__propagated, 
         :actual,
         :hidden,
         :dsl_location
        ]
      
      def valid_tag_name?
        self.class.valid_tag_types.include?(name)
      end
      
      private
      
      def raise_error_if_conflicting_tags(existing_tag, new_tag)
        if (existing_tag.class != new_tag.class) or
            (existing_tag.kind_of?(Assignment) and existing_tag.value != new_tag.value)
          raise Error, "The tags (#{existing_tag.inspect}) and (#{new_tag.inspect}) are conflicting"
        end
      end

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

    end
  end
end

