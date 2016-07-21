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
  class FileGenerator
    require_relative('file_generator/content_input')
    require_relative('file_generator/yaml_object')

    # opts can have keys
    #   :filter
    def self.generate_yaml_object(parse_template_type, content_input, dsl_version, opts = {})
      template_class = Template.template_class(parse_template_type, dsl_version)
      template_class.create_for_generation(content_input, opts).generate_yaml_object
    end

    # opts can have keys
    #   :filter
    def self.generate_yaml_text(parse_template_type, content_input, dsl_version, opts = {})
      template_class = Template.template_class(parse_template_type, dsl_version)
      template_class.create_for_generation(content_input, opts).generate_yaml_text
    end
  end
end

