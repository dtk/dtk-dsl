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
      # TODO: change so have both Components and Component and use for assembly level and under nodes
      class AssemblyComponents < self
        def parser_output_type
          :hash
        end

        def generate!
          # TODO: stub; components would be child generate to component
          @content.each { |component| add component}
        end
        
        def parse!
          # TODO: later will parse components array as well
          merge(:name => 'assembly_wide', 'components' => input_array)
        end
      end
    end
  end
end

