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
      if service_instance?
        process_service_instance
      elsif common_module?
        process_common_module
      end
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

    def process_service_instance
      ret = { 'nodes' => {}, 'components' => [] }

      @input_hash.each do |element|
        if element.is_a?(Hash)
          process_hash!(element, ret)
        elsif element.is_a?(String)
          process_string!(element, ret)
        else
          fail Error.new("Unexpected service instance content format #{element}")
        end
      end

      ret.delete('nodes') if ret['nodes'].empty?
      ret.delete('components') if ret['components'].empty?
      ret
    end

    def new_format?
      new_format = false

      if service_instance?
        new_format = true if @input_hash.is_a?(Array)
      elsif common_module?
        if assemblies = @input_hash['assemblies']
          if assembly = (assemblies.values || {}).first
            new_format = true if assembly.is_a?(Array)
          end
        end
      end

      new_format
    end

    private

    def process_assembly(assembly_content)
      ret_assembly = { 'nodes' => {}, 'components' => [] }

      assembly_content.each do |content|
        if content.is_a?(Hash)
          process_hash!(content, ret_assembly)
        else
          process_string!(content, ret_assembly)
        end
      end

      ret_assembly.delete('nodes') if ret_assembly['nodes'].empty?
      ret_assembly.delete('components') if ret_assembly['components'].empty?
      ret_assembly
    end

    def process_hash!(content, ret_assembly)
      name  = content.keys.first
      value = content[name]

      if cmp_name = is_component?(name)
        ret_assembly['components'] << { cmp_name => value }
      elsif node_name = is_node?(name)
        ret_assembly['nodes'].merge!(node_name => process_node(value))
      else
        ret_assembly.merge!(content)
      end
    end

    def process_string!(content, ret_assembly)
      if cmp_name = is_component?(content)
        ret_assembly['components'] << cmp_name
      end
    end

    def is_component?(name)
      if match = name.match(Regex[:component])
        return match[1]
      end
    end

    def is_node?(name)
      if match = name.match(Regex[:node])
        return match[1]
      end
    end

    def service_instance?
      @parse_template_type == :service_instance || @parse_template_type == :service_module_summary
    end

    def common_module?
      @parse_template_type == :common_module || @parse_template_type == :common_module_summary
    end

    def process_node(nodes)
      nodes_hash = { 'components' => [] }

      nodes.each do |node|
        next unless node
        if node.is_a?(String) 
          if match = node.match(Regex[:component])
            nodes_hash['components'] << match[1]
          else
            nodes_hash['components'] << node
          end
        elsif node.is_a?(Hash)
          if node.keys.first == 'attributes' || node.keys.first == :attributes
            nodes_hash.merge!(node)
          else
            if match = node.keys.first.match(Regex[:component])
              nodes_hash['components'] << { match[1] => node[node.keys.first] }
            end
          end
        else
          fail Error.new("unexpected #{node}")
        end
      end

      nodes_hash.delete('components') if nodes_hash['components'].empty?
      nodes_hash
    end
  end
end