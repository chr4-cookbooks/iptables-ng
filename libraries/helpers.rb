module IptablesNG
  module Helpers
    module_function

    def tables
      node['iptables-ng']['enabled_tables'] || %w( raw mangle nat filter )
    end

    # linux/netfilter/x_tables.h doesn't restrict chains very tightly,
    # just a string token with a max length of XT_EXTENSION_MAXLEN 
    # (29 in all 3.x headers I could find).
    def chain_name_regexp
      /^[-\w\.]+$/
    end

    def resources(resource, run_context)
      run_context.resource_collection.select do |r|
        r.is_a?(resource)
      end
    end

    def chains(run_context)
      resources(Chef::Resource::IptablesNGChain, run_context)
    end

    def rules(run_context)
      resources(Chef::Resource::IptablesNGRule, run_context)
    end
  end
end
