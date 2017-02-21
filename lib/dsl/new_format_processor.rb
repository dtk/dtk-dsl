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
  class NewFormatProcessor
    Regex = { :node => Regexp.new(/^node\[(.*)\]$/), :component => Regexp.new(/^component\[(.*)\]$/) }

    def initialize(parse_template_type, input_hash)
      @parse_template_type = parse_template_type
      @input_hash = input_hash
    end

    def process
      if @parse_template_type == :service_instance
        generate_service_instance
      else
        process_common_module
      end
    end

    def generate_service_instance
      new_hash = {}

      if nodes = @input_hash.delete('nodes')
        nodes.each do |name, node|
          @input_hash.merge!("node[#{name}]" => generate_node(node))
        end
      end

      @input_hash
    end

    def generate_node(node)
      if components = node.delete('components')
        components.each do |component|
          if component.is_a?(String)
            node.merge!("component[#{component}]" => {})
          else
            cmp_name = component.keys.first
            node.merge!("component[#{cmp_name}]" => component[cmp_name])
          end
        end
      end
      node
    end

    def process_common_module
      new_hash = {}

      if assemblies = @input_hash.delete('assemblies')
        assemblies.each do |name, assembly|
          new_hash.merge!(name => process_assembly(assembly))
        end
      end

      @input_hash['assemblies'] = new_hash
      @input_hash
    end

    def new_format?
      new_format = true
      if assemblies = @input_hash['assemblies']
        assemblies.each do |name, assembly|
          if assembly['components'] || assembly['nodes']
            new_format = false
            break
          end
        end
      end
      new_format
    end

    private

    def process_assembly(assembly_content)
      ret_assembly = { 'nodes' => {}, 'components' => [] }
      assembly_content.each do |name, content|
        if match = name.match(Regex[:node])
          ret_assembly['nodes'].merge!(match[1] => process_node(content))
        elsif match = name.match(Regex[:component])
          ret_assembly['components'] << { match[1] => content }
        else
          ret_assembly.merge!(name => content)
        end
      end

      ret_assembly
    end

    def process_node(node)
      nodes_hash = { 'components' => [] }
      node.each do |n|
        if n.is_a?(String)
          if match = n.match(Regex[:component])
            nodes_hash['components'] << match[1]
          else
            nodes_hash['components'] << n
          end
        elsif n.is_a?(Hash)
          if n.keys.first == 'attributes' || n.keys.first == :attributes
            nodes_hash.merge!(n)
          else
            if match = n.keys.first.match(Regex[:component])
              nodes_hash['components'] << { match[1] => n[n.keys.first] }
            end
          end
        else
          fail Error.new("unexpected #{n}")
        end
      end

      nodes_hash
    end
  end
end