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
 class ServiceAndComponentInfo::TransformTo
    class Info < ServiceAndComponentInfo::Info
      require_relative('info/input_files')
      require_relative('info/service')
      require_relative('info/component')
      require_relative('info/kubernetes_crd')

      # This is for mapping to module directories (not service instance directories)
      INFO_HASH = {
        :service_info => {
          :input_files => {
            :module => {
              :regexps => [Regexp.new("dtk\.module\.yaml$")]
            },
            :assemblies => {
              :regexps => [Regexp.new("assemblies/(.*)\.dtk\.assembly\.(yml|yaml)$"), ]
            },
            :legacy_assemblies => {
              :regexps => [Regexp.new("assemblies/([^/]+)/assembly\.(yml|yaml)$")]
            }
          }
        },
        :component_info => {
          :input_files => {
            :module => {
              :regexps => [Regexp.new("dtk\.module\.yaml$")]
            }
          }
        },
        :kubernetes_crd => {
          :input_files => {
            :module => {
              :regexps => [Regexp.new("dtk\.module\.yaml$")]
            }
          }
        }
      }

    end
  end
end
