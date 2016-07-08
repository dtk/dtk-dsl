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

module DTK
  module DSL    
    require_relative('dsl/error')
    require_relative('dsl/dsl_version')
    require_relative('dsl/file_type')
    require_relative('dsl/file_obj')
    require_relative('dsl/yaml_helper')
    require_relative('dsl/directory_parser')
    require_relative('dsl/directory_generator')
    require_relative('dsl/input_output_common')
    # input_output_common must be before file_parser and file_generator
    require_relative('dsl/file_parser')
    require_relative('dsl/file_generator')
    require_relative('dsl/template')

  end
end
