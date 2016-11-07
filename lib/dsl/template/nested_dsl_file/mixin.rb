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
    module NestedDSLFile
      module Mixin
        attr_reader :nested_file_content

        private
        def generation_initialize_nested_dsl_files
          # If there iis any nested dsl in conetnt being generated then tese wil go on @nested_file_content
          # which has keys that are relative paths and values being 
          @nested_file_content = {}
        end

        def generate_nested_dsl_file_path__content_array
          @nested_file_content.inject([]) do |a, (path, content)|
            a + [{ :path => path, :content => YamlHelper.generate(content) }]
          end
        end

        # returns the path of a file if @yaml_object should be written to a nested dsl file
        def nested_dsl_file?
          val(:DSLLocation)
        end

        def add_nested_dsl_file_import?(nested_dsl_file)
          unless val(:HiddenDSLLocation) 
            if @yaml_object.kind_of?(::Hash)
              add_import_statement!(nested_dsl_file, @yaml_object)
            elsif @yaml_object.kind_of?(::Array)
              @yaml_object << add_import_statement!(nested_dsl_file)
            else
              raise Error, "Unexpected that @yaml_object is not a hash or array" 
            end
          end
        end
        
        def add_import_statement!(nested_dsl_file, yaml_object = nil)
          yaml_object ||= empty_yaml_object(:output_type => :hash)
          set_generation_hash(yaml_object, :Import, nested_dsl_file)
          yaml_object
        end
        
        def select_yaml_object_or_nested_dsl_file
          if nested_dsl_file = nested_dsl_file?
            add_nested_dsl_file_import?(nested_dsl_file)
            empty_nested_dsl_file_hash(nested_dsl_file, InputOutputCommon.obj_type(@yaml_object))
          else
            @yaml_object
          end
        end

        def empty_nested_dsl_file_hash(nested_dsl_file, output_type)
          @top.nested_file_content[nested_dsl_file] ||= empty_yaml_object(output_type: output_type) 
        end

      end
    end
  end
end

