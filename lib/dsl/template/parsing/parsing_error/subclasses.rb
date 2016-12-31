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
module DTK::DSL; class Template                   
  module Parsing                   
    class ParsingError
      class MissingKeyValue < self
        def initialize(key, opts = {})
          error_msg = "Missing value for key '#{key}'"
          super(error_msg, opts)
        end
      end
      
      class WrongObjectType < self
        def initialize(obj, correct_ruby_types, opts = {})
          correct_ruby_types = [correct_ruby_types] unless correct_ruby_types.kind_of?(::Array)
          error_msg = 
            if correct_ruby_types.size == 1
              "The key's value should have type #{correct_ruby_types.first}"
            else
              "The key's value should be one of the types (#{correct_ruby_types.join(' ')})"
            end
          error_msg << (obj.nil? ? ", but has null value" : ", but has type #{input_class_string(obj)}")
          super(error_msg, opts)
        end
        
        private
        
        def input_class_string(obj)
          if obj.kind_of?(::Hash) 
            'Hash'
          elsif obj.kind_of?(::Array)
            'Array'
          elsif obj.kind_of?(::String)
            'String'
          # elesif ..TODO: should we handle Booleans in special way
          else
            # demodularize
            obj.class.to_s.split('::').last
          end
        end

      end
    end
  end
end; end


