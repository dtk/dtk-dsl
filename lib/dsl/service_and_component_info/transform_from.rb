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
  module ServiceAndComponentInfo
    class TransformFrom
      require_relative('transform_from/info')
      require_relative('transform_from/parser')

      attr_reader :namespace, :module_name, :version, :output_path_hash_pairs
      def initialize(namespace, module_name, version = nil)
        @namespace = namespace
        @module_name = module_name
        @version     = version 

        # dynamically computed
        @output_path_hash_pairs = {} 
      end

      def info_processor(info_type)
        case info_type 
        when :service_info then Info::Service.new(self)
        when :component_info then Info::Component.new(self)
        else
          fail Error, "Unexpected info_type '#{info_type}'"
        end
      end

      def output_path_text_pairs
        @output_path_hash_pairs.inject({}) { |h, (path, hash_content)| h.merge(path => YamlHelper.generate(hash_content)) }
      end

      def update_or_add_output_hash!(path, hash_content)
        @output_path_hash_pairs.merge!(path => hash_content)
      end

    end
  end
end
