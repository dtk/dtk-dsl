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
class DTK::DSL::FileParser::Template
  class V1
    class Assembly < self
      module Constant
        module Variations
        end

        extend ClassMixin::Constant
        # TODO: might put constants used in many templates in ClassMixin::Constant
        Name = 'name'
        Description = 'description'
        Attributes  = 'attributes'
      end

      def parse!
        @output.set(:Name, constant_matches(input_hash, :Name))
        @output.set(:Description, constant_matches?(input_hash, :Description))
        # Aldin: 06/27/2016: replace @output.set(:Attributes, input_hash[:attributes])
        # with a call to  parse_child(:attributes, ..) which then wil make calls if non empy list to parse_child(:attribute, ..) 
        @output.set(:Attributes, constant_matches?(input_hash, :Attributes))

        # TODO: This is a catchall that removes ones we so far are parsing and then has catch all
        input_hash.delete('name')
        input_hash.delete('description')
        input_hash.delete('attributes')
        @output.merge!(input_hash)
      end
    end
  end
end

