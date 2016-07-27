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
  class Template
    require_relative('template/constant_class_mixin')
    require_relative('template/parsing')
    require_relative('template/generation')
    require_relative('template/diff')
    require_relative('template/loader')

    include Parsing::Mixin
    extend Parsing::ClassMixin
    include Generation::Mixin
    extend Generation::ClassMixin
    include Diff::Mixin
    extend Diff::ClassMixin

    # opts can have keys
    #   :file_obj
    #   :parent_key
    def self.create_for_parsing(raw_input, opts = {})
      new(:parsing, opts.merge(:raw_input => raw_input))
    end
      
    # Content is of type InputOutput::Canonical Array or Hash
    # opts can have keys
    #   :filter
    def self.create_for_generation(content, opts = {})
      new(:generation, opts.merge(:content => content))
    end

    def initialize(type, opts = {})
      case @type = type
      when :parsing then parsing_initialize(opts)
      when :generation then generation_initialize(opts)
      else raise Error, "Illegal type '#{type}'"
      end
    end

    def set(constant, val)
      case @type
      when :parsing then parsing_set(constant, val)
      when :generation then generation_set(constant, val)
      end 
    end

    def req(key)
      case @type
      when :generation then generation_req(key)
      else fail(Error,"Method 'req' undefined for type '#{@type}'")
      end
    end

    def val(key)
      case @type
      when :generation then generation_val(key)
      else fail(Error,"Method 'val' undefined for type '#{@type}'")
      end
    end

    def set?(constant, val)
      set(constant, val) unless val.nil?
    end    

    def merge(hash)
      case @type
      when :parsing then parsing_merge(hash)
      when :generation then generation_merge(hash)
      end
    end

    def add(array_element)
      case @type
      when :parsing then parsing_add(array_element)
      when :generation then generation_add(array_element)
      end
    end

    private

    def self.template_class(parse_template_type, dsl_version)
      Loader.template_class(parse_template_type, :dsl_version => dsl_version)
    end

    def template_class(parse_template_type)
      self.class.template_class(parse_template_type, template_version)
    end

    def canonical_key(constant)
      constant_class.canonical_value(constant)
    end

    def constant_class
      self.class::Constant
    end
  end
end

