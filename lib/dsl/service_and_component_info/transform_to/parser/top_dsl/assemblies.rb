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
  class ServiceAndComponentInfo::TransformTo::Parser
    class TopDSL
      class Assemblies < self
        require_relative('assemblies/workflows')
        require_relative('assemblies/node_bindings')
        def update_output_hash?
          if module_content = input_files(:module)
            if assemblies = module_content.content_hash['assemblies']
              (output_hash['assemblies'] ||= {}).merge!(assemblies)
            end
          end
          # input_files(:assemblies).content_hash_array.each do |input_hash|
          #   name          = input_hash['name'] || raise_error_missing_field('name')
          #   assembly_hash = input_hash['assembly'] || raise_error_missing_field('assembly')

          #   assembly_content = {}
          #   if description  = input_hash['description']
          #     assembly_content.merge!('description' => description)
          #   end
            
          #   assembly_content.merge!(assembly_hash)
            
          #   if workflows = Workflows.hash_content?(input_hash)
          #     assembly_content.merge!('workflows' => workflows)
          #   end

          #   if node_bindings = input_hash['node_bindings']
          #     # convert node_bindings to node attributes
          #     NodeBindings.add_node_properties!(assembly_content, node_bindings) 
          #   end
          #   (output_hash['assemblies'] ||= {}).merge!(name => assembly_content)
          # end

        end

      end
    end
  end
end
