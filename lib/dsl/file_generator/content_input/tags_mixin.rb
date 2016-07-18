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
  class FileGenerator
    class ContentInput
      module TagsMixin

        attr_reader :tags

        def initialize_tags!
          @tags = []
        end
        private :initialize_tags!

        def add_tags!(new_tags)
          new_tags = [new_tags] unless new_tags.kind_of?(Array)
          @tags += new_tags
          @tags.uniq!
          self
        end

        def add_tags?(new_tags)
          add_tags!(new_tags) unless new_tags.nil? or new_tags.empty?
        end

        def has_tag?(tag)
          @tags.include?(tag)
        end

        private

        def add_tags_to_obj?(obj, new_tags) 
          obj.add_tags!(new_tags) if obj.respond_to?(:add_tags!)
          obj
        end

        def obj_has_tag?(obj, tag)  
          if obj.respond_to?(:tags)
            obj.has_tag?(tag)
          else
            # vacuously succeeds
            true
          end
        end

      end
    end
  end
end

