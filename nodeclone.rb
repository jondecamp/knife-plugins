# Author:  Jon DeCamp (jon.decamp@nordstrom.com)
# Copyright 2012 Nordstrom, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module MyKnifePlugins
  class NodeClone < Chef::Knife

    deps do
      require 'chef/search/query'
    end

    banner "knife node clone SOURCE TARGET[s]"

    option :env,
      :short => '-e',
      :long => '--env',
      :boolean => true,
      :description => "Clone environment of SOURCE to TARGET[s]"

    option :runlist,
      :short => '-r',
      :long => '--runlist',
      :boolean => true,
      :description => "Clone run_list of SOURCE to TARGET[s]"

    def run
      if name_args.size < 2
        ui.fatal "You need to specify a SOURCE and at least one TARGET node"
        show_usage
        exit 1
      end

      unless config[:runlist] || config[:env]
        ui.fatal "You need to specify environment and/or run_list to clone."
        show_usage
        exit 1
      end

      source = name_args.shift
      targets = name_args
      source_env = ""
      source_run_list = ""

      query_nodes = Chef::Search::Query.new

      query = "name:#{source}"

      query_nodes.search('node', query) do |node_item|
        source_env = "#{node_item.chef_environment}"
        source_run_list = node_item.run_list
      end

      targets.each do |target|
        query = "name:#{target}"

        query_nodes.search('node', query) do |node_item|
          if config[:env] and ! source_env.empty?
            node_item.chef_environment(source_env)
            node_item.save
            ui.msg "New env for #{node_item.name} = #{node_item.chef_environment}"
          end

          if config[:runlist] and ! source_run_list.empty?
            node_item.run_list(source_run_list)
            node_item.save
            ui.msg "New run_list for #{node_item.name} = #{node_item.run_list}"
          end
        end
      end
    end
  end
end
