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
    module Generation
      module Mixin
        # Main template-specific generate call; Concrete classes overwrite this
        def generate!
          raise Error::NoMethodForConcreteClass.new(self.class)
        end

        # This is overwritten if template can conditionally generate elements
        def generate?
          generate!
        end

        attr_reader :filter, :top

        # opts can have keys
        #  :content (required)
        #  :filter
        #  :top
        def generation_initialize(opts = {})
          unless content = opts[:content]
            raise Error, "Unexpected that opts[:content] is nil"
          end
          @content     = content
          @filter      = opts[:filter]
          @yaml_object = empty_yaml_object(content_input: content)
          @top         = opts[:top] || self
          generation_initialize_nested_dsl_files
        end
        private :generation_initialize

        # generate_yaml_object? can be ovewritten
        def generate_yaml_object?
          generate?
          is_empty?(@yaml_object) ? nil : @yaml_object
        end

        def generate_yaml_object
          generate!
          @yaml_object
        end
        
        def generate_yaml_text
          self.generate!
          YamlHelper.generate(@yaml_object)
        end

        # Array where each element has keys :path and :content
        def generate_yaml_file_path__content_array(top_file_path)
          self.generate!
          [{ :path => top_file_path, :content => YamlHelper.generate(@yaml_object) }] + generate_nested_dsl_file_path__content_array
        end


        # The methods yaml_object_type can be set on concrete class; it wil be set if input and output types are different
        def yaml_object_type
          nil
        end
        
        private

        def generate_child(parse_template_type, content)
          if content.nil?
            nil
          else
            template_class(parse_template_type).create_for_generation(content, :filter => @filter, :top => @top).generate_yaml_object
          end
        end
        
        def generate_child_elements(parse_template_type, content_elements)
          unless content_elements.nil?
            template_class(parse_template_type).generate_elements(content_elements, self)
          end
        end

        # opts can have keys
        #  :content_input
        #  :output_type
        def empty_yaml_object(opts = {})
          if output_type = opts[:output_type] || self.yaml_object_type
            FileGenerator::YamlObject.create(:output_type => output_type)
          elsif content_input = opts[:content_input]
            FileGenerator::YamlObject.create(:input => content_input)
          else
            raise Error, "If opts[:content_input] is nil, self.yaml_object_type or opts[:output_type] must have a value" 
          end
        end

        def set_generation_hash(hash, constant, val)
          unless val.nil? or is_empty?(val)
            hash[canonical_key(constant)] = val
          end
        end

        def is_empty?(obj)
          obj.respond_to?(:empty?) and obj.empty?
        end

        def generation_val(key)
          @content.val(key)
        end

        def generation_req(key)
          @content.req(key)
        end

        def skip_for_generation?
          @content.skip_for_generation?
        end

        def generation_set(constant, val)
          set_generation_hash(select_yaml_object_or_nested_dsl_file, constant, val)
        end

        def generation_merge(hash)
          select_yaml_object_or_nested_dsl_file.merge!(hash)
        end        

        def generation_add(array_element)
          select_yaml_object_or_nested_dsl_file << array_element
        end

        def generation_set_scalar(scalar)
          @yaml_object = scalar
        end

      end
    end
  end
end

