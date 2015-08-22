module IptablesNG
  module Helpers
    TABLES ||= %w( raw mangle nat filter )

    module_function

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

    def config(version, tables, run_context)
      config = [
        '# This file is managed by Chef.',
        '# Manual changes will be overwritten!'
      ]

      # Select actionable chains from resource collection
      curr_chains = chains(run_context).reject do |c|
        c.should_skip?(c.action)
      end

      # Selection actionable rules from resource collection
      curr_rules = rules(run_context).reject do |r|
        r.should_skip?(c.action)
      end

      # Sort chains to reduce unnecessary reloads
      # Sort rules to give user control over priority
      curr_chains.sort! { |a, b| a.name <=> b.name }
      curr_rules.sort! { |a, b| a.name <=> b.name }

      # Capture version-specific rules
      v_rules = curr_rules.select do |r|
        Array(r.ip_version).include?(version)
      end

      # Configure table rules
      tables.each do |table|
        # Initialize table
        config << "*#{table}"

        # Append config for table-appropriate chains
        curr_chains.select { |c| c.table == table }.each do |c|
          config << c.to_s
        end

        # Append config for table-appropriate rules
        vt_rules = v_rules.select { |r| r.table == table }

        vt_rules.sort { |a, b| a.name <=> b.name }.each do |vr|
          config << vr.to_s
        end

        config << "COMMIT\n"
      end
      config
    end
  end
end
