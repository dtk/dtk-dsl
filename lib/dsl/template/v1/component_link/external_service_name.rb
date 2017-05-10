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
    module ExternalServiceName
      SERVICE_NAME_VAR = '*'
      COMPONENT_VAR = '+'
      MAPPINGS = {
        short_form: {
          generate: "#{SERVICE_NAME_VAR}/#{COMPONENT_VAR}",
          parse_regexp: /^([^\/\]\[]+)\/(.+$)/
        },
        long_form: {
          generate: "service[#{SERVICE_NAME_VAR}]/#{COMPONENT_VAR}",
          parse_regexp:  /^service\[([^\]]+)\]\/(.+$)/
            }
      }
      PARSE_REGEXPS = MAPPINGS.values.map { |info| info[:parse_regexp] }
      
      CANONICAL_FORM = :short_form
      
      def self.dependent_component_ref(external_service_name, component_ref)
        MAPPINGS[CANONICAL_FORM][:generate].sub(SERVICE_NAME_VAR, external_service_name).sub(COMPONENT_VAR, component_ref)
      end
      
      # returns [dependency, external_service_name] or nil if no external_service_name
      def self.parse?(input_string)
        # assume that cant have form ATOMIC-TERM/... where ATOMIC-TERM is not a external name
        PARSE_REGEXPS.each do |regexp|
          if input_string =~ regexp
            external_service_name, dependency = [$1, $2]
            return [dependency, external_service_name]
          end
        end
        nil
      end
      
    end
  end
end
