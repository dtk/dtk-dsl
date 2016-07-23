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
    class V1
      class Component < self
        module Constant
          module Variations
          end
          
          extend ClassMixin::Constant

          Attributes     = 'attributes'
          ComponentLinks = 'component_links'
        end
        
        def parser_output_type 
          :hash
        end
        
        def parse!
          # TODO: This is a catchall that removes ones we so far are parsing and then has catch all
          if input_string = input_string?
            merge(input_string => FileParser::Output.create(:output_type => :hash))
          elsif input_hash = input_hash?
            merge(input_hash)
          else
            raise parsing_error(:WrongObjectType, @input, [::String, ::Hash])
          end
        end
      end
    end
  end
end
