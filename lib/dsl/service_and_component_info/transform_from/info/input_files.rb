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
  class ServiceAndComponentInfo::TransformFrom
    class InputFiles
      def initialize(regexps)
        @regexps = regexps

        # dyanmically set
        @ndx_file_hash_content = {} #indexed by file hash name
      end

      def match?(path)
        @regexps.find { |regexp| path =~ regexp }
      end

      def add_content!(path, text_content)
        file_obj = FileObj.new(nil, path, :content => text_content)
        @ndx_file_hash_content.merge!(path => YamlHelper.parse(file_obj))
      end

      def content_hash_array
        @ndx_file_hash_content.values
      end

      def content_hash
        fail Error, "Unexpected that @ndx_file_hash_content.size != 1" unless @ndx_file_hash_content.size == 1
        @ndx_file_hash_content.values.first
      end

    end
  end
end
