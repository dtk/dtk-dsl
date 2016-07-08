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
      require_relative('parsing/parsing_error')

      module Mixin
        def parse
          parse!
          @output
        end

        # The method parser_output_type can be set on concrete class; it wil be set if input and output types are different
        def parser_output_type
          nil
        end
        
        private
        
        def parsing_initialize(opts = {})
          unless raw_input = opts[:raw_input]
            raise Error, "Unexpected that opts[:raw_input] is nil"
          end
          @input      = FileParser::Input.create(raw_input)
          @output     = empty_parser_output(@input)
          @file_obj   = opts[:file_obj]
          @parent_key = opts[:parent_key]
        end
        
        def empty_parser_output(input)
          if parser_output_type 
            FileParser::Output.create(:output_type => parser_output_type)
          else
            FileParser::Output.create(:input => input)
          end
        end

        # Main parse call; Each concrete class should overwrite this
        def parse!
          raise Error::NoMethodForConcreteClass.new(self.class)
        end

        def parsing_set(constant, val)
          @output.set(constant, val)
        end

        def parsing_merge(hash)
          @output.merge!(hash)
        end

        def parsing_add(array_element)
          @output << array_element
        end
        
        # opts can have keys
        #  :parent_key
        def parse_child(parse_template_type, input, opts = {})
          if input.nil?
            nil
          else
            template_class = Loader.template_class(parse_template_type, :template_version => template_version)
            template_class.create_for_parsing(input, opts.merge(:file_obj => @file_obj)).parse
          end
        end
        
        def parent_key?(index = nil)
          if @parent_key
            index ? "#{@parent_key}[#{index}]" : parent_key
          end
        end
        
        def input_hash
          @input_hash ||= @input.kind_of?(FileParser::Input::Hash) ? @input : raise_input_error(::Hash)
        end
        
        def input_array
          @input_array ||= @input.kind_of?(FileParser::Input::Array) ? @input : raise_input_error(::Array)
        end
        
        def input_string
          @input_string ||= @input.kind_of?(::String) ? @input : raise_input_error(::String)
        end
        
        def constant_matches(object, constant)
          constant_class.matches?(object, constant) || raise_missing_key_value(constant)
        end
        
        def constant_matches?(object, constant)
          constant_class.matches?(object, constant)
        end

        def raise_input_error(correct_ruby_type)
          raise parsing_error(:WrongObjectType, @input, correct_ruby_type)
        end
        
        def raise_missing_key_value(constant)
          key = canonical_key(constant)
          raise parsing_error(:MissingKeyValue, key)
        end

        # args can have form 
        #  (:ParsingErrorName,*parsing_error_params) or
        #  (parsing_error_params)
        def parsing_error(*args)
          if error_class = ParsingError.error_class?(args)
            error_params = args[1..args.size-1]
            error_class.new(*error_params, :file_obj => @file_obj, :qualified_key => @parent_key)
          else
            ParsingError.new(*args, :file_obj => @file_obj, :qualified_key => @parent_key)
          end
        end
        

      end
    end
  end
end
