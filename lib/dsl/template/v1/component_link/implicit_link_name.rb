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
  class Template::V1::ComponentLink
    module ImplicitLinkName
      # opts can have keys:
      #   :parent
      #   :donot_raise_error
      def self.parse(dependent_component_ref, opts = {})
        last_component = dependent_component_ref.split('/').last
        # remove title if it exists
        title_split = last_component.split('[')
        case title_split.size
        when 1
          return last_component
        when 2
          return title_split[0] if title_split[1] =~ /\]$/
        end
        unless opts[:donot_raise_error]
          raise opts[:parent].parsing_error("The term '#{dependent_component_ref}' is an ill-formed component link dependency reference")
        end
        nil
      end

      def self.implicit_link_name(dependent_component_ref)
        # This should not return nil, but allowing it to be more robust
        parse(dependent_component_ref, donot_raise_error: true)
      end
    end
  end
end    
