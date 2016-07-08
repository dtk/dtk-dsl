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
        def generate_yaml_object
          generate!
          @yaml_object
        end
        
        def generate_yaml_text
          self.generate!
          YamlHelper.generate(@yaml_object)
        end

        # The methods yaml_object_type can be set on concrete class; it wil be set if input and output types are different
        def yaml_object_type
          nil
        end
        
        private

        def generation_initialize(opts = {})
          unless content = opts[:content]
            raise Error, "Unexpected that opts[:content] is nil"
          end
          @content = content
          @yaml_object = empty_yaml_object(content)
        end

        # Main generate call; Each concrete class should overwrite this
        def generate!
          raise Error::NoMethodForConcreteClass.new(self.class)
        end

        # opts can have keys
        #  :parent_key
        def generate_child(parse_template_type, content)
          if content.nil?
            nil
          else
            template_class = Loader.template_class(parse_template_type, :template_version => template_version)
            template_class.create_for_generation(content).generate_yaml_object
          end
        end
        
        def empty_yaml_object(content_input)
          if self.yaml_object_type
            FileGenerator::YamlObject.create(:output_type => yaml_object_type)
          else
            FileGenerator::YamlObject.create(:input => content_input)
          end
        end

        def generation_set(constant, val)
          @yaml_object[canonical_key(constant)] = val
        end

        def generation_merge(hash)
          @yaml_object.merge!(hash)
        end        

        def generation_add(array_element)
          @yaml_object << array_element
        end

        def generation_val(key)
          @content.val(key)
        end

        def generation_req(key)
          @content.req(key)
        end

      end
    end
  end
end

