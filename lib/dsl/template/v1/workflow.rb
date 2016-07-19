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
class DTK::DSL::Template
  class V1
    class Workflow < self
      # TODO: DTK-2554: workflows: Aldin: 
      # cut and paste from import_task_templates and its subfunctions in 
      # https://github.com/dtk/dtk-server/blob/DTK-2554/application/model/module/service_module/dsl/assembly_import/adapters/v4.rb
      # might break this into multiple files underneath this to handle sub parts of workflow
      # these dont have to be templates; just files included by # require_relative('workflow/...)
      module Constant
        module Variations
        end

        extend ClassMixin::Constant
        # TODO: might put constants used in many templates in ClassMixin::Constant
        # TODO: DTK-2554: workflows: Aldin: put in sample cut and paste constant from
        # https://github.com/dtk/dtk-server/blob/DTK-2554/application/model/module/service_module/dsl/assembly_import/adapters/v4.rb
        CreateWorkflowAction = 'create'

      end

      def parser_output_type
        :hash
      end

      def parse!
        # TODO: catchall
        merge(input_hash)
      end
    end
  end
end

# TODO: DTK-2554: workflows: Aldin: 
# here is an example of output form for one element; this is vcase that is treated specially; if match
# CreateWorkflowAction use __create_action
=begin

{"__create_action"=>
  {"task_action"=>"__create_action",
   "content"=>
    {"subtasks"=>
      [{"name"=>"bigtop_multiservice", "components"=>["bigtop_multiservice"]},
       {"name"=>"bigtop hiera", "components"=>["bigtop_multiservice::hiera"]},
       {"name"=>"bigtop_base", "components"=>["bigtop_base"]},
       {"name"=>"namenode", "components"=>["hadoop::namenode"]},
       {"name"=>"if needed leave safemode",
        "actions"=>["hadoop::namenode.leave_safemode"]},
       {"name"=>"namenode smoke test",
        "actions"=>["hadoop::namenode.smoke_test"]},
       {"name"=>"datanodes",
        "ordered_components"=>["hadoop::common_hdfs", "hadoop::datanode"]},
       {"name"=>"hdfs directories for spark",
        "component"=>["hadoop::hdfs_directories"]},
       {"name"=>"spark master and client",
        "components"=>["spark::master", "spark::client"]},
       {"name"=>"spark workers",
        "ordered_components"=>["spark::common", "spark::worker"]},
       {"name"=>"zeppelin server", "components"=>["zeppelin::server"]}]}}}
=end
