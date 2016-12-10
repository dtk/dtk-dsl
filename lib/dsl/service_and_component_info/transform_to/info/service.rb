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
  class ServiceAndComponentInfo::TransformTo
    class Info
      class Service < self
        def compute_outputs!
          path        = top_level_dsl_path
          output_hash = output_file_hash(path)

          top_dsl_file_hash_content!(output_hash)
          update_or_add_output_hashes!(output_hash)
        end
      
        private
      
        def info_type
          :service_info
        end

        def top_dsl_file_hash_content!(output_hash)
          top_dsl_parser::ModuleInfo.update_output_hash?(output_hash, self) 
          top_dsl_parser::Dependencies.update_output_hash?(output_hash, self)
          top_dsl_parser::Assemblies.update_output_hash?(output_hash, self)
          output_hash
        end

        def assembly_path_from_name(name)
          "#{name}.assembly.yaml"
        end

        def update_or_add_output_hashes!(output_hash)
          if assemblies = output_hash['assemblies']
            assemblies.each do |name, content|
              assembly_content = { 'name' => name, 'dsl_version' => output_hash['dsl_version'] }
              update_or_add_output_hash!(assembly_path_from_name(name), assembly_content.merge(content))
            end
          end

          if module_refs = output_hash['service_module_refs']
            update_or_add_output_hash!('module_refs.yaml', module_refs)
          end
        end
      end
      
      # TODO: DTK-2765: Aldin: this should be changed
      def top_dsl_parser
        @top_dsl_parser ||= Parser::TopDSL
      end

      # TODO: DTK-2765: Aldin: this is not being used as intended; it should be path of output file. Might be the way it is used still getting right answer, but this shoudl be fixed
      def top_level_dsl_path
        @top_level_dsl_path ||= FileType::CommonModule::DSLFile::Top.canonical_path
      end

    end
  end
end
