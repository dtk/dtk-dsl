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
  class FileType
    class MatchingFiles
      attr_reader :file_type_instance, :file_paths
      def initialize(file_type_instance)
        @file_type_instance  = file_type_instance
        @file_paths          = []
      end
      private :initialize

      def add_file_path!(file_path)
        @file_paths << file_path
        self
      end

      # Returns array of MatchingFiles
      def self.matching_files_array(file_type_classes, file_paths)
        ndx_ret = {}
        file_type_classes = [file_type_classes] unless file_type_classes.kind_of?(Array)
        file_type_classes.each do |file_type_class|
          file_paths.each do |file_path|
            if file_type_instance = file_type_class.file_type_instance_if_match?(file_path)
              file_type_instance_index = file_type_instance.index
              if matching_index = ndx_ret.keys.find { |index| index == file_type_instance_index }
                ndx_ret[matching_index].add_file_path!(file_path)
              else
                ndx_ret[file_type_instance_index] = new(file_type_instance).add_file_path!(file_path)
              end
            end
          end
        end
        ndx_ret.values
      end

    end
  end
end


