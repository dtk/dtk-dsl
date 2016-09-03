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
      class SemanticParse < InputOutputCommon::Canonical::Hash
        def attribute_value(attr_name)
          if attribute = attributes[attr_name.to_s]
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
            fail Error::Usage, "The value '#{type_value}' of attribute '#{name}/type' is not a legal node type"
          end
        end
        
        private

        def name
          val(:Name)
        end

        def attributes
          # TODO: change to be computed during semantic parse to be a hash of Attribute::SemanticParse objects 
          @attributes ||= val(:Attributes) || {}
        end

        def value_from_attribute_object(attribute)
          # TODO: change when change attributes to be semantic parse object
          attribute.req(:Value)
        end
      end
    end
  end
end

