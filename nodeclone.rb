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
