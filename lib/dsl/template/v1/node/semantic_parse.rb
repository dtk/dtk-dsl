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
  class Template::V1
    class Node
      class SemanticParse < InputOutputCommon::SemanticParse::Hash
        def attribute_value(attr_name)
          if attribute = attribute?(attr_name)
            value_from_attribute_object(attribute)
          end
        end
        
        # possible values of type are :node or :node_group
        def type
          type_value = attribute_value(:type)
          if type_value.nil?
            :node
          elsif type_value == 'group'
            :node_group
          else
            type_attribute = attribute(:type)
            fail Error::Usage, "The value '#{type_value}' assigned to attribute '#{type_attribute.qualified_name}' is not a legal node type"
          end
        end
        
        private

        def attribute(attr_name)
          attribute?(attr_name) || fail(Error, "Unexpected that attribute?(attr_name) is nil")
        end

        def attribute?(attr_name)
          attributes[attr_name.to_s]
        end

        def attributes
          @attributes ||= val(:Attributes) || {}
        end

        def value_from_attribute_object(attribute)
          attribute.req(:Value)
        end
      end
    end
  end
end

