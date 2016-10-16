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
    class Match
      def initialize(file_type)
        @file_type = file_type
      end
      private :initialize

      # opts can have keys:
      #  :exact (Booelan) - meaning regexp completely matches file_path; otherwise it means jsut match the end
      def self.matches?(file_type, file_path, opts = {})
        new(file_type).matches?(file_path, opts = {})
      end
      
      def matches?(file_path, opts = {})
        file_path = remove_multiple_slashes(file_path)
        if opts[:exact]
          file_path =~ regexp_exact
        else
          # extra check to see if regexp is just for file part or has '/' seperators
          # if just for file then we can have more restrictive match
          if regexp.source =~ Regexp.new('/')
            file_path =~ regexp_match_end
          else
            file_path.split('/').last =~ regexp_exact
          end
        end
      end
      
      private

      def remove_multiple_slashes(string)
        string.split('/').reject { |el| el.empty?}.join('/')
      end

      def regexp
        @regexp ||=  @file_type.regexp
      end

      def regexp_exact
        @regexp_exact ||= Regexp.new("^#{regexp.source}$")
      end

      def regexp_match_end
        @regexp_match_end ||= Regexp.new("#{regexp.source}$")
      end

    end
  end
end
