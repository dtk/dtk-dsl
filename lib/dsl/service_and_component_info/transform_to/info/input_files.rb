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
  class ServiceAndComponentInfo::TransformTo::Info
    class InputFiles < ServiceAndComponentInfo::Info::InputFiles
      def add_canonical_hash_content!(path, canonical_hash_content)
        raise_error_if_not_canonical_hash(canonical_hash_content)
        add_hash_content!(path, canonical_hash_content)
      end

      def content_canonical_hash
        content_hash
      end

      private

      def raise_error_if_not_canonical_hash(obj)
        unless obj.kind_of?(InputOutputCommon::Canonical::Hash)
          raise Error, "Expecting input of type 'InputOutputCommon::Canonical::Hash', but '#{obj.class}' was given" 
        end
      end

    end
  end
end
