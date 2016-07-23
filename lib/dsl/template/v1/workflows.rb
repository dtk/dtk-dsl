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
      class Workflows < self
        def parser_output_type
          :hash
        end
        
        def parse!
          workflows = 
            if @input.kind_of?(FileParser::Input::Hash)
              [@input]
            elsif @input.kind_of?(FileParser::Input::Array)
              @input
            else
              raise parsing_error("Ill-formed workflow(s) section")
            end

          workflows.each_with_index do |workflow, i|
            merge parse_child(:workflow, workflow, :parent_key => parent_key?(i))
          end
        end
      end
    end
  end
end
