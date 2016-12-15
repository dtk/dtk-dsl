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
    module Generation
      module ClassMixin
        # Main template-specific generate call; Concrete classes overwrite this
        def generate_elements(_content_elements, _parent)
          raise Error::NoMethodForConcreteClass.new(self)
        end

        private

        def generate_element(content, parent)
          create_for_generation(content, generation_opts(parent)).generate_yaml_object
        end

        def generate_element?(content, parent)
          create_for_generation(content, generation_opts(parent)).generate_yaml_object?
        end

        def generation_opts(parent)
          { :filter => parent.filter, :top => parent.top }
        end

      end
    end
  end
end
