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
class DTK::DSL::FileParser::Template
  class V1
    class CommonModule < CommonModuleSummary
      module Constant
        include CommonModuleSummary::Constant

        module Variations
          include CommonModuleSummary::Constant::Variations
        end

        extend ClassMixin::Constant
        Assemblies = 'assemblies'
      end

      def parse!
        super
        assemblies = constant_matches(input_hash, :Assemblies)
        @output.set(:Assemblies, parse_child(:assemblies, assemblies, :parent_key => Constant::Assemblies))
      end
    end
  end
end
