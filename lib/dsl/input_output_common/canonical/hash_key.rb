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
  class InputOutputCommon::Canonical
    module HashKey
      # Top level for common module
      DSLVersion       = :dsl_version
      Assemblies       = :assemblies
      ComponentDefs    = :component_defs
      DependentModules = :dependent_modules
      ModuleRef        = :module

      # Top level for Service Instance
      Assembly = :asssembly

      # Used in assembly
      Workflows  = :workflows

      # Used in nested module
      Module = :module
      Version = :version      

      # Used in component links
      ExternalServiceName = :external_service_name

      # Used in workflows
      Subtasks          = :subtasks
      SubtaskOrder      = :subtask_order
      Node              = :node
      ExecutionBlocks   = :exec_blocks
      Flatten           = :flatten
      Action            = :action
      Actions           = :actions
      OrderedComponents = :ordered_components     

      # Used at multiple levels
      Name           = :name
      Description    = :description
      Namespace      = :namespace
      ModuleName     = :module_name
      ModuleVersion  = :version
      Attributes     = :attributes
      Value          = :value
      Nodes          = :nodes
      Target         = :target
      Components     = :components
      ComponentLinks = :component_links
      Links          = :links

      # meta info
      Import                = :import
      HiddenImportStatement = :hidden_import_statement

      def self.index(output_key)
        begin
          const_get(output_key.to_s)
        rescue
          raise Error, "Illegal output hash key '#{output_key}'"
        end
      end
    end
  end
end

