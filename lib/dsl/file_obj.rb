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
  class FileObj
    # opts can have keys
    #  :dir_path
    #  :current_dir
    #  :content 
    #  :file_parser - this is class
    def initialize(file_type, file_path, opts = {})
      @file_type         = file_type
      @path              = file_path
      @dir_path          = opts[:dir_path]
      @current_dir       = opts[:current_dir]  
      @content           = opts[:content]
      @file_parser_class = opts[:file_parser] || FileParser
      # below computed on demand
      @parsed_templates = {}
      @yaml_parse_hash = nil
    end

    attr_accessor :yaml_parse_hash    
    attr_reader :file_type

    # opts can have keys:
    #  :dsl_version
    def add_parse_content!(parse_template_type, opts = {})
      parse_content(parse_template_type, opts)
      self
    end
    def parse_content(parse_template_type, opts = {})
      @parsed_templates[parse_template_type] ||= @file_parser_class.parse_content(parse_template_type, self, opts)
    end

    def content_or_raise_error
      @content || raise(Error::Usage, error_msg_no_content)
    end
    def content
      @content || raise(Error, 'Method should not be called if @content is nil')
    end
    def content?
      @content 
    end

    def raise_error_if_no_content
      raise(Error::Usage, error_msg_no_content) unless @content
      self
    end

    def raise_error_if_no_content_flag(type)
      raise(Error::Usage, error_msg_no_content_flag(type)) unless @content
      self
    end

    def exists?
      ! @content.nil?
    end

    def path?
      @path
    end

    def hash_content?
      @file_parser_class.yaml_parse!(self) if exists?
    end

    private

    def error_msg_no_content
      if @path
        "No #{file_ref} found at '#{@path}'"
      else
        "Cannot find a #{file_ref} in the #{dir_ref} or ones nested under it"
      end
    end

    def error_msg_no_content_flag(type)
      type = type.to_s
      type = type.slice!(0..(type.index('_')-1))
      if @path
        "No #{file_ref} found at '#{@path}'"
      else
        "Cannot find a #{type} #{file_ref} in the #{dir_ref}"
      end
    end

    def file_ref
      (@file_type && @file_type.print_name) || 'DSL file'
    end

    def dir_ref
      if @dir_path 
        "specified directory '#{@dir_path}'" 
      elsif @current_dir
        "current directory '#{@current_dir}'"
      else
        'directory'
      end
    end
  end
end



