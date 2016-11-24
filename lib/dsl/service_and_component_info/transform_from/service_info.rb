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
  class ServiceAndComponentInfo::TransformFrom
    class ServiceInfo < self
      require_relative('service_info/base')
      # base must go first
      require_relative('service_info/assemblies')
      require_relative('service_info/dependencies')

      def compute_outputs!
        top_level_dsl_path  = FileType::CommonModule::DSLFile::Top.canonical_path
        output_files = OutputFiles.new.add_content!(top_level_dsl_path, top_dsl_file_hash_content)
        add_to_indexed_output_files!(:top_level_dsl_file, output_files)        
      end

      private

      def info_type
        :service_info
      end

      def top_dsl_file_hash_content
        hash_content = top_dsl_file_header_hash
        if dependencies = Dependencies.hash_content?(self)
          hash_content =  hash_content.merge('dependencies' => dependencies)
        end
        if assemblies = Assemblies.hash_content?(self)
          hash_content = hash_content.merge('assemblies' => assemblies)
        end
        hash_content
      end

    end
  end
end
