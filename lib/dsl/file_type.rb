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
  # This has specific file type meta info
  class FileType
    Types = 
      [
       {
         :type           => :common_module,
         :regexp         => "/dtk\.module\.(yml|yaml)/",
         :canonical_path => 'dtk.module.yaml', 
         :print_name     => 'module DSL file'
       },
       {
         :type           => :service_instance,
         :regexp         => "/dtk\.service\.(yml|yaml)/",
         :canonical_path => 'dtk.service.yaml', 
         :print_name     => 'service DSL file'
       }
      ]
      # regexps purposely do not have ^ or $ so calling function can insert these depending on context

    Types.each do |type_info|
      # convert to camel case
      class_name = type_info[:type].to_s.gsub(/(?<=_|^)(\w)/){$1.upcase}.gsub(/(?:_)(\w)/,'\1')
      class_eval("
         class #{class_name} < self
           def self.type
             :#{type_info[:type]}
           end
           def self.print_name
             '#{type_info[:print_name]}'
           end
           def self.canonical_path
             '#{type_info[:canonical_path]}'
           end

           private

           def self.regexp
             #{type_info[:regexp]}
           end
        end")
    end

    def self.create_path_info
      DirectoryParser::PathInfo.new(regexp)
    end
    
    # opts can have keys:
    #  :exact - Booelan (default: false) - meaning regexp completely matches file_path
    def self.matches?(file_path, opts = {})
      DirectoryParser::PathInfo.matches?(file_path, regexp, opts)
    end
  end
end


