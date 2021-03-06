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
  # This refers to semnatic dsl version
  class DSLVersion < ::String
    #versions in DSL_VERIONS are ordered so that most recent versions are last
    DSL_VERSIONS = ['1.0.0']

    def self.legal?(str)
      DSL_VERSIONS.include?(str)
    end 

    def self.lataset
      DSL_VERSIONS.last
    end

    def self.default
      lataset
    end
  end
end
