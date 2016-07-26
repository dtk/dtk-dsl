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
class DTK::DSL::Template
  class V1
    class Attribute < self
      module Constant
        module Variations
        end

        extend ClassMixin::Constant
        Name  = 'name'
        Value = 'value'
      end

      def parser_output_type
        :hash
      end

      def self.parse_elements(input, parent_info)
        ret = file_parser_output_array
        input_hash(input).each do |name, value|
          ret << parse_element({ 'name' => name, 'value' => value}, parent_info, :index => name)
        end
        ret
      end

      def parse!
        set :Name, constant_matches(input_hash, :Name)
        # constant_matches? in case null value
        set :Value, constant_matches?(input_hash, :Value)
      end
    end
  end
end

