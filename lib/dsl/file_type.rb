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
    require_relative('file_type/match')
    require_relative('file_type/matching_files')

    # opts can have keys:
    #  :exact - Booelan (default: false) - meaning regexp completely matches file_path
    def self.matches?(file_path, opts = {})
      Match.matches?(self, file_path, opts)
    end
    def matches?(file_path, opts = {})
      Match.matches?(self, file_path, opts)
    end

    # Returns array of MatchingFiles or nil
    def self.matching_files_array?(file_type_classes, file_paths)
      MatchingFiles.matching_files_array?(file_type_classes, file_paths)
    end

    SERVICE_INSTANCE_NESTED_MODULE_DIR = 'modules'
    TYPES = {
      CommonModule::DSLFile::Top => {
        :regexp                => Regexp.new("dtk\.module\.(yml|yaml)"),
        :canonical_path_lambda => lambda { |_params| 'dtk.module.yaml' }, 
        :print_name            => 'module DSL file'
      },
      ServiceInstance::DSLFile::Top => {
        :regexp                => Regexp.new("dtk\.service\.(yml|yaml)"),
        :canonical_path_lambda => lambda { |_params| 'dtk.service.yaml' }, 
        :print_name            => 'service DSL file'
      },
      ServiceInstance::NestedModule => {
        :instance_match_lambda => lambda { |path| path =~ Regexp.new("^#{SERVICE_INSTANCE_NESTED_MODULE_DIR}/([^/]+)/.+$") && { :module_name => $1 } },    
        :base_dir_lambda       => lambda { |params| "#{SERVICE_INSTANCE_NESTED_MODULE_DIR}/#{params[:module_name]}" },
        :print_name            => 'nested module file'
      },
      ServiceInstance::NestedModule::DSLFile::Top => {
        :regexp                => Regexp.new("#{SERVICE_INSTANCE_NESTED_MODULE_DIR}/[^/]+/dtk\.module\.(yml|yaml)"),
        :canonical_path_lambda => lambda { |params| "#{SERVICE_INSTANCE_NESTED_MODULE_DIR}/#{params[:module_name]}/dtk.module.yaml" },
        :print_name            => 'nested module DSL file'
      }
    }
    # regexps, except for one in :instance_match_lambda, purposely do not have ^ or $ so calling function can insert these depending on context

    def self.print_name
      matching_type_def(:print_name)
    end

    def self.regexp
      matching_type_def(:regexp)
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

    def self.base_dir
      nil
    end
    # This can be over-written
    def base_dir
      self.class.base_dir
    end


    # If match it retuns a hash with params that can be used to create a File Type instance
    def self.file_type_instance_if_match?(file_path)
      # just want to match 'this' and dont want to match parent so not using matching_type_def
      if instance_match_lambda = TYPES[self][:instance_match_lambda]
        if hash_params_for_new = instance_match_lambda.call(file_path)
          new(hash_params_for_new)
        end
      end
    end

    def self.type_level_type
      raise Error::NoMethodForConcreteClass.new(self)
    end

    # This can be over-written
    def index
      self.class.to_s
    end

    private

    BASE_CLASS = FileType 
    # The method matching_type_def starts at tpe and looks to see if or recursive parents have definition
    def self.matching_type_def(key, klass = nil, orig_klass = nil)
      klass      ||= self
      orig_klass ||= self
      fail Error, "Type '#{orig_klass}' is not in TYPES" if klass == BASE_CLASS 
      if type_def_hash = TYPES[klass] 
        type_def_hash[key]
      else
        matching_type_def(key, klass.superclass, orig_klass)
      end
    end
    def matching_type_def(key)
      self.class.matching_type_def(key)
    end

    def self.canonical_path_lambda
      matching_type_def(:canonical_path_lambda)
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


