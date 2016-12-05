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
    class ModuleRef
      attr_reader :namespace, :module_name, :version
      def initialize(namespace, module_name, version)
        @namespace = namespace
        @module_name = module_name
        @version     = version || 'master'
      end
      
      NAMESPACE_NAME_DELIM = '/'
      
      def combined_module_form
        { "#{@namespace}#{NAMESPACE_NAME_DELIM}#{@module_name}" => @version }
      end
      
      def raise_error_if_conflict(ndx_existing_modules)
        if matching_module_info = ndx_existing_modules[@module_name]
          fail Error::Usage, conflict_error_msg(matching_module_info) unless match?(matching_module_info)
        end
      end
      
      def print_form
        "#{@namespace}#{NAMESPACE_NAME_DELIM}#{@module_name}(#{@version})"
      end
      
      private
      
      def match?(module_info2)
        @version == module_info2.version and @module_name == module_info2.module_name and @namespace == module_info2.namespace
      end
      
      def conflict_error_msg(matching_module_info)
        "Conflicting versions of module '#{@module_name}': '#{print_form}' vs '#{matching_module_info.print_form}'"
      end
        
    end
  end
end
