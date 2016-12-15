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
    # assumption is that where this included could have a Variations module
    module ClassMixin
      module Constant
        # opts can have keys:
        #   :set_matching_key - if specified this wil be an empty array to add matching_key to
        def matches?(object, constant, opts = {})
          unless object.nil?
            variations = variations(constant)
            if object.is_a?(Hash)
              if matching_key = hash_key_if_match?(object, variations)
                opts[:set_matching_key] << matching_key if opts[:set_matching_key]
                object[matching_key]
              end
            elsif object.is_a?(String) || object.is_a?(Symbol)
              variations.include?(object.to_s)
            else
              fail Error.new("Unexpected object class (#{object.class})")
            end
          end
        end

        def matching_key_and_value?(hash, constant)
          variations = variations(constant)
          if matching_key = hash_key_if_match?(hash, variations)
            { matching_key => hash[matching_key] }
          end
        end

        def all_string_variations(*constants)
          constants.flat_map { |constant| variations(constant, string_only: true) }.uniq
        end

        def its_legal_values(constant)
          single_or_set = variations(constant, string_only: true)
          if single_or_set.is_a?(Array)
            "its legal values are: #{single_or_set.join(',')}"
          else
            "its legal value is: #{single_or_set}"
          end
        end

        def canonical_value(constant)
          # self. is important beacuse want to evalute wrt to class that calls this
          begin
            self.const_get(constant.to_s)
          rescue
            raise Error, "Illegal Input parsing constant '#{constant}'"
          end
        end

        private

        def variations(constant, opts = {})
          # use of self:: and self. are important because want to evalute wrt to module that pulls this in
          variations = self::Variations.const_get(constant.to_s)
          string_variations = variations.map(&:to_s)
          opts[:string_only] ? string_variations : string_variations + variations.map(&:to_sym)
         rescue
          # if Variations not defined
          term = canonical_value(constant)
          opts[:string_only] ? [term.to_s] : [term.to_s, term.to_sym]
        end

        def hash_key_if_match?(hash, variations)
          variations.find { |key| hash.key?(key) }
        end

      end
    end
  end
end
