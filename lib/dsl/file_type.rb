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
  class FileType
    require_relative('file_type/subclasses')

    SERVICE_INSTANCE_NESTED_MODULE_DIR = 'modules'
    TYPES = {
      CommonModule => {
        :regexp         => Regexp.new("dtk\.module\.(yml|yaml)"),
        :canonical_path => lambda { |opts| 'dtk.module.yaml' }, 
        :print_name     => 'module DSL file'
      },
      ServiceInstance => {
        :regexp         => Regexp.new("dtk\.service\.(yml|yaml)"),
        :canonical_path => lambda { |opts| 'dtk.service.yaml' }, 
        :print_name     => 'service DSL file'
      },
      ServiceInstanceNestedModule => {
        :regexp         => Regexp.new("#{SERVICE_INSTANCE_NESTED_MODULE_DIR}/[^/]+/dtk\.module\.(yml|yaml)"),
        :base_dir       => lambda { |opts| "#{SERVICE_INSTANCE_NESTED_MODULE_DIR}/#{opts[:module_name]}" },
        :canonical_path => lambda { |opts| "#{SERVICE_INSTANCE_NESTED_MODULE_DIR}/#{opts[:module_name]}/dtk.module.yaml" },
        :print_name     => 'nested module DSL file'
      }
    }
    # regexps purposely do not have ^ or $ so calling function can insert these depending on context

    # For each method have class and instance versions
    def self.print_name
      TYPES[self][:print_name]
    end
    def print_name
      self.class.print_name
    end

    def self.regexp
      TYPES[self][:regexp]
    end
    def regexp
      self.class.regexp
    end

    def self.canonical_path
      canonical_path_lambda.call({})
    end
    # This can be over-written
    def canonical_path
      self.class.canonical_path
    end
  
    def self.backup_path
      backup_path_from_canonical_path(canonical_path)
    end
    def backup_path
      self.class.backup_path_from_canonical_path(canonical_path)
    end

    def self.create_path_info
      DirectoryParser::PathInfo.new(regexp)
    end
    def create_path_info
      self.class.create_path_info
    end

    # opts can have keys:
    #  :exact - Booelan (default: false) - meaning regexp completely matches file_path
    def self.matches?(file_path, opts = {})
      DirectoryParser::PathInfo.matches?(file_path, regexp, opts)
    end
    def matches?
      self.class.matches?
    end

    private

    def self.canonical_path_lambda
      TYPES[self][:canonical_path]
    end

    FILE_PREFIX = 'bak'
    def self.backup_path_from_canonical_path(canonical_path)
      split_path = canonical_path.split('/')
      file_path = split_path.pop
      backup_file_path = "#{FILE_PREFIX}.#{file_path}"
      split_path.empty? ? backup_file_path : "#{split_path.join('/')}/#{backup_file_path}"      
    end

  end
end


