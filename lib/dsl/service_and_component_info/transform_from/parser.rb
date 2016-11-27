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
    class Parser
      require_relative('parser/top_dsl')
      
      attr_reader :output_hash, :info_object
      def initialize(output_hash, info_object)
        @output_hash         = output_hash
        @info_object         = info_object
        @indexed_input_files = info_object.indexed_input_files
      end
      private :initialize
      
      def self.update_output_hash?(output_hash, info_object)
        new(output_hash, info_object).update_output_hash?
        output_hash
      end
      
      private
      
      def input_files(type)
        input_files?(type) || raise(Error, "Unexpected that no indexed_input_files of type '#{type}'")
      end
      
      def input_files?(type)
        @indexed_input_files[type]
      end
      
      def raise_error_missing_field(key)
        raise Error, "Unexpected that field '#{key}' is missing"
      end
      
    end
  end
end

