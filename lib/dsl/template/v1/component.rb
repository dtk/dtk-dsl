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
          if input_string?
            parse_when_string!
          elsif input_hash = input_hash?
            parse_when_hash!
          else
            raise parsing_error(:WrongObjectType, @input, [::String, ::Hash])
          end
        end

        def parse_when_string!
          set :Name, input_string
        end

        def parse_when_hash!
          unless input_hash.size == 1 and input_hash.values.first.kind_of?(::Hash)
            raise parsing_error("Component is ill-formed; it must be string or hash with has value")
          end
          name = input_hash.keys.first
          properties = input_hash.values.first
          set :Name, name
          set? :Attributes, parse_child(:attributes, constant_matches?(properties, :Attributes), :parent_key => nested_parent_key(Constant::Attributes))

          # TODO: This is a catchall that removes ones we so far are parsing and then has catch all
          properties.delete('attributes')
          merge properties
        end

      end
    end
  end
end

