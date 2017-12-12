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
 class ServiceAndComponentInfo
    class Info
      require_relative('info/input_files')

      attr_reader :indexed_input_files, :module_ref
      def initialize(parent)
        @parent      = parent
        @module_ref  = parent.module_ref
        # indexed by input file type
        @indexed_input_files = ret_indexed_input_files(info_type)
      end

      def compute_outputs!        
        raise Error::NoMethodForConcreteClass.new(self.class)
      end

      def output_path_hash_pairs
        @parent.output_path_hash_pairs
      end

      def output_path_text_pairs
        @parent.output_path_text_pairs
      end

      private

      # indexed by input file type
      def ret_indexed_input_files(input_type)
        input_type_hash(input_type)[:input_files].inject({}) { |h, (k, v) | h.merge(k => input_files_class.new(v[:regexps])) }
      end

      def input_type_hash(input_type)
        self.class::INFO_HASH[input_type] || fail(Error, "Illegal input_type '#{input_type}'")
      end

      def output_file_hash(path)
        @parent.output_path_hash_pairs[path] || {}
      end

      def update_or_add_output_hash!(path, hash_content)
        @parent.update_or_add_output_hash!(path, hash_content)
      end

      def input_files_class
        @input_files_class ||= @parent.class::Info::InputFiles
      end

    end
  end
end
