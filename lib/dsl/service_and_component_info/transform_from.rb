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
  module ServiceAndComponentInfo
    class TransformFrom
      require_relative('transform_from/input_files')
      require_relative('transform_from/output_files')
      require_relative('transform_from/service_info')

      # This is for mapping to module directories (not service instance directories)
      INFO_HASH = {
        :service_info => {
          :input_files => {
            :assemblies => {
              :regexps => 
              [
               Regexp.new("assemblies/(.*)\.dtk\.assembly\.(yml|yaml)$"), 
               Regexp.new("assemblies/([^/]+)/assembly\.(yml|yaml)$") #Legacy form
              ]
            },
            :module_refs =>  {
              :regexps => [Regexp.new("module_refs\.yaml$")]
            }
          }

        }
      }

      attr_reader :indexed_input_files
      def initialize(namespace, module_name, version = nil)
        @namespace = namespace
        @module_name = module_name
        @version     = version 

        # both indexed_input_files are indexed by indexed_output_files are indexed by the file type
        @indexed_input_files = ret_indexed_input_files(info_type)
        # dynamically computed
        @indexed_output_files = {} 
      end

      def output_file_array(type)
        output_files_object = @indexed_output_files[type] || fail(Error, "Illegal output type '#{type}'")
        output_files_object.outputs
      end
      
      private

      # TODO: hard coded now
      DSL_VERSION = '1.0.0'
      def top_dsl_file_header_hash
        {
          'dsl_version' => DSL_VERSION,
          'module'      => "#{@namespace}/#{@module_name}",
          'version' => @version || 'master'
        }
      end

      def add_to_indexed_output_files!(type, output_files)
        @indexed_output_files.merge!(type => output_files)
      end
                                  
      # indexed by file type
      def ret_indexed_input_files(info_type)
        info_type_hash(info_type)[:input_files].inject({}) { |h, (k, v) | h.merge(k => InputFiles.new(v[:regexps])) }
      end

      def info_type_hash(info_type)
        INFO_HASH[info_type] || fail(Error, "Illegal info_type '#{info_type}'")
      end

    end
  end
end
