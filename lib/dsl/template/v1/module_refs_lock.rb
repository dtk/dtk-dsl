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
    class ModuleRefsLock < self
      def parser_output_type
        :array
      end

      def parse!
        input_hash.each_pair do |module_ref_term, info_hash|
          add parse_element(module_ref_term, info_hash)
        end
      end
      
      private
      
      def parse_element(module_ref_term, info_hash)
        ret = self.class.file_parser_output_hash
        
        version                = parse_version(info_hash)
        namespace, module_name = parse_module_ref_term(module_ref_term)
        
        ret.set :Namespace, namespace
        ret.set :ModuleName, module_name
        ret.set :ModuleVersion, version
        ret
      end
      
      def parse_version(info_hash)
        unless version = info_hash['version']
          raise parsing_error("The missing version info")
        end
        # TODO: check syntax of version
        version
      end
      
      # returns [namespace, module_name]
      def parse_module_ref_term(module_ref_term)
        split = split_by_delim(module_ref_term)
        unless split.size == 2
          raise parsing_error("The term '#{module_ref_term}' is an ill-formed module reference")
        end
        namespace, module_name = split
        [namespace, module_name]
      end
      
      MODULE_NAMESPACE_DELIMS = ['/', ':']
      
      def split_by_delim(str)
        if matching_delim = MODULE_NAMESPACE_DELIMS.find { |delim| str =~ Regexp.new(delim) }
          str.split(matching_delim)
        else
          [str]
        end
      end

    end
  end
end
