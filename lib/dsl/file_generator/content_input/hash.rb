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
      class Hash < InputOutputCommon::Canonical::Hash
        include Mixin

        def initialize(*args)
          super
          initialize_tags_and_id_handle!
        end

        # opts can have keys
        #  :tags
        #  :tag
        def set(output_key, val, opts = {})
          ret = super(output_key, val)
          tags = opts[:tag] || opts[:tags]
          add_tags_to_obj?(ret, tags) unless tags.nil?
          ret
        end

        # opts can have keys
        #  :tag - tag to filter on
        def val(output_key, opts = {})
          ret = super(output_key)
          if tag = opts[:tag]
            ret = nil unless obj_has_tag?(ret, tag)
          end
          ret
        end

      end
    end
  end
end

