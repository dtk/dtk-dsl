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
class DTK::DSL::Template
  class V1
    class Assembly < self
      module Constant
        module Variations
        end

        extend ClassMixin::Constant
        # TODO: might put constants used in many templates in ClassMixin::Constant
        Name        = 'name'
        Description = 'description'
        Attributes  = 'attributes'
        Nodes       = 'nodes'
        Components  = 'components'
      end

      def generate!
        # TODO: stub that dumps out uninterpreted
        merge @content
      end

      def parse!
        set :Name, constant_matches(input_hash, :Name)
        set :Description, constant_matches?(input_hash, :Description)
        set :Attributes, parse_child(:attributes, constant_matches?(input_hash, :Attributes), :parent_key => Constant::Attributes)

        nodes               = parse_child(:nodes, constant_matches?(input_hash, :Nodes), :parent_key => Constant::Nodes)
        assembly_components = parse_child(:assembly_components, constant_matches?(input_hash, :Components), :parent_key => Constant::Components)

        # add assembly wide components to nodes as part of assembly_wide_node
        if assembly_components && !assembly_components.empty?
          nodes << assembly_components
        end

        set :Nodes, nodes

        # TODO: This is a catchall that removes ones we so far are parsing and then has catch all
        input_hash.delete('name')
        input_hash.delete('description')
        input_hash.delete('attributes')
        input_hash.delete('nodes')
        merge input_hash
      end
    end
  end
end

