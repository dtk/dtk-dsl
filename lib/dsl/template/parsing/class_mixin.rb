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
  class Template
    module Parsing
      module ClassMixin
        # Main template-specfic parse call; Concrete classes overwrite this
        def parse_elements(_input_elements, _parent_info)
          raise Error::NoMethodForConcreteClass.new(self)
        end
        
        private

        # opts can have keys
        #  :index
        def parse_element(input, parent_info, opts = {})
          if input.nil?
            nil
          else
            file_obj   = parent_info.parent.file_obj 
            parent_key = parent_key(parent_info, opts[:index])
            create_for_parsing(input, :file_obj => file_obj, :parent_key => parent_key).parse
          end
        end

        def parent_key(parent_info, index)
          ret = "#{parent_info.parent.parent_key}"
          ret << '/' unless ret.empty?
          ret << parent_info.key_type.to_s
          ret << "[#{index}]" unless index.nil?
          ret
        end

        def file_parser_output_array
          FileParser::Output.create(:output_type => :array)
        end
        
        def file_parser_output_hash
          FileParser::Output.create(:output_type => :hash)
        end

        def input_hash?(input)
          input.kind_of?(FileParser::Input::Hash)
        end

        def input_hash(input)
          input_hash?(input) ? input : raise_input_error(::Hash)
        end

        def input_array?(input)
          input.kind_of?(FileParser::Input::Array)
        end

        def input_array(input)
          input_array?(input) ? input : raise_input_error(::Array)
        end
      end
    end
  end
end
