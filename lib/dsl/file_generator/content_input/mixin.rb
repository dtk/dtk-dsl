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
    # Mixin for tags and id_handle object attributes
    module Mixin
      attr_reader :tags
      def initialize_tags_and_id_handle!
        @tags      = []
        @id_handle = nil
      end

      def set_id_handle(model_object)
        @id_handle = model_object.id_handle
      end
      
      def id_handle
        @id_handle || raise(Error,"@id_handle is not set")
      end
        
      def add_tags!(new_tags)
        Tag.add_tags!(@tags, new_tags)
        self
      end

      def add_tags?(new_tags)
        add_tags!(new_tags) unless new_tags.nil? or new_tags.empty?
      end
      
      def matches_tag_type?(tag_type)
        !! @tags.find { |tag| Tag.matches_tag_type?(tag_type, tag) }
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

