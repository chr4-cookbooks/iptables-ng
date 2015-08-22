
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
  end
end
