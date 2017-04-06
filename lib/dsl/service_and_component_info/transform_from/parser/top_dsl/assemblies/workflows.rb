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
  class ServiceAndComponentInfo::TransformFrom::Parser
    class TopDSL::Assemblies 
      module Workflows
        def self.hash_content?(assembly_hash)
          if workflows = assembly_hash['workflow'] || assembly_hash['workflows'] || assembly_hash['actions']
            if workflow_name = workflows['assembly_action']
              # this is legacy workflow
              workflows_without_name = workflows.inject({}) { |h, (k, v)| k == 'assembly_action' ? h : h.merge(k => v) }
              { workflow_name =>  workflows_without_name }
            else
              workflows
            end
          end
        end

      end
    end
  end
end
