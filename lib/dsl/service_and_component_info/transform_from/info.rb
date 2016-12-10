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
 class ServiceAndComponentInfo::TransformFrom
    class Info < ServiceAndComponentInfo::Info
      require_relative('info/service')
      require_relative('info/component')
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
        },
        :component_info => {
          :input_files => {
            :component_dsl_file => {
              :regexps => [Regexp.new("dtk\.model\.yaml$")], 
            },
            :module_refs =>  {
              :regexps => [Regexp.new("module_refs\.yaml$")]
            }
          }
        }
      }

      private

      def top_dsl_parser
        @top_dsl_parser ||= Parser::TopDSL
      end

      def top_level_dsl_path  
        @top_level_dsl_path ||= FileType::CommonModule::DSLFile::Top.canonical_path
      end

    end
  end
end
