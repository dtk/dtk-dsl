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
    module Parsing
      class ParentKey < ::String
        DELIM = '/'
        def self.parent_key(parent_info, index)
          ret = new
          ret << "#{parent_info.parent.parent_key}"
          ret << DELIM unless ret.empty?
          ret << parent_info.key_type.to_s
          ret << Index.with_delims(index) unless index.nil?
          ret
        end

        def create_qualified_key
          QualifiedKey.new(qualified_key_elements) 
        end

        private

        UNKNOWN_INDEX = '*'
        def qualified_key_elements
          split(DELIM).map do |key_seqment| 
            type, index = Index.parse_segment(key_seqment)
            QualifiedKey::Element.new(type, index || UNKNOWN_INDEX)
          end
        end

        module Index
          LEFT_DELIM = '['
          RIGHT_DELIM = ']'
          def self.with_delims(index)
            "#{LEFT_DELIM}#{index}#{RIGHT_DELIM}"
          end

          # returns [type, index] where index can be nil
          def self.parse_segment(key_seqment)
            type = index = nil
            split_on_left = key_seqment.split(LEFT_DELIM)
            if split_on_left.size == 1
              type = key_seqment
            else 
              type = split_on_left.shift

              # find index
              # being robust if index has index symbols in it by looking for leftmost left deleim and rightmost right delim
              rest = split_on_left.join(LEFT_DELIM)
              split_on_right = rest.split(RIGHT_DELIM)
              if split_on_right.size == 1
                index = split_on_right.first 
                index << RIGHT_DELIM if index.include?(LEFT_DELIM) && !index.include?(RIGHT_DELIM)
              else
                split_on_right.pop # get rid of end
                index = split_on_right.join(RIGHT_DELIM)
              end
            end
            [type, index]
          end
          
        end
      end
    end
  end
end


