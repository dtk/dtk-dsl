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
      class ComponentDef < self
        require_relative('component_def/semantic_parse')

        module Constant
          module Variations
          end
          
          extend ClassMixin::Constant
        end

        ### For parsing
        def parser_output_type 
          :hash
        end

        def self.parse_elements(input_hash, parent_info)
          input_hash.inject(file_parser_output_hash) do |h, (name, component_def)|
            h.merge(name => parse_element(component_def, parent_info, :index => name))
          end
        end

        def parse!
          # TODO: This does not parse and just passes through; parse routines from dtk-server will be migrated
          # here
          merge input_hash
        end

      end
    end
  end
end

