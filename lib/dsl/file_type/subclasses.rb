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
    class CommonModule < self
      def self.top_level_type
        :common_module
      end

      class DSLFile < self
        class Top < self
        end
      end
    end

    class ModuleRefsLock < self
      def self.top_level_type
        :module_refs_lock
      end

      class DSLFile < self
        class Top < self
        end
      end
    end

    class ServiceInstance < self
      def self.top_level_type
        :service_instance
      end

      class DSLFile < self
        class Top < self
          class Hidden < self
          end
        end
      end

      class NestedModule < self
        attr_reader :module_name
        # params can have keys:
        #  :module_name (required)
        def initialize(params = {})
          unless @module_name = params[:module_name]
            raise Error, "Unexpected that opts[:module_name] is nil"
          end
        end

        def index
          "#{super}--#{@module_name}"
        end

        def canonical_path
          self.class.canonical_path_lambda.call(:module_name => @module_name)
        end

        def base_dir
          matching_type_def(:base_dir_lambda).call(:module_name => @module_name)
        end

        class DSLFile < self
          class Top < self
          end
        end
      end
    end
  end
end
