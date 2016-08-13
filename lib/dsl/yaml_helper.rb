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
require 'yaml'
module DTK::DSL
  module YamlHelper
    # Returns hash if succsefully parse; otherwise raises error
    def self.parse(file_obj)
      begin
        ::YAML.load(file_obj.content)
      rescue Exception => e
        raise Error::Usage, yaml_parsing_error_msg(e, file_obj)
      end
    end

    def self.generate(yaml_object)
      ::YAML.dump(convert_for_yaml_dump(yaml_object))
    end

    private
    
    def self.yaml_parsing_error_msg(e, file_obj)
      file_ref = FileParser.file_ref_in_error(file_obj)
      yaml_err_msg = e.message.gsub(/\(<unknown>\): /,'').capitalize 
      "YAML parsing error#{file_ref}:\n#{yaml_err_msg}"
    end

    # this method converts embedded hash and array objects to be ::Hash and ::Array objects
    # so YAML rendering does not have objects in it
    def self.convert_for_yaml_dump(yaml_object)
      if yaml_object.kind_of?(::Array)
        ret = []
        yaml_object.each { |el| ret << convert_for_yaml_dump(el) }
        ret
      elsif yaml_object.kind_of?(::Hash)
        yaml_object.inject({}) { |h, (k, v)| h.merge(k => convert_for_yaml_dump(v)) }
      else
        yaml_object
      end
    end
  end
end
