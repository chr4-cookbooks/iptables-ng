iptables-ng CHANGELOG
=====================

This file is used to list changes made in each version of the iptables-ng cookbook.

3.0.1
-----

- Fix issue with resource cloning in Chef 13

3.0.0
-----

Release to workaround cloning issues, for the upcoming Chef-13 release:
- Removed the feature to automatically run `iptables-ng::install` upon LWRP
  usage. It's now required to manually run `iptables-ng::install` before using
  the LWRPs. This can be achieved by adding the following before using the
  LWRPs for the first time (also make sure it's only included once):
```ruby
include_recipe 'iptables-ng::install'
```
- Removed the feature to automatically create new custom chains when using the
  `iptables_ng_rule` provider. Custom chains are now required to be added
  manually before using them:
```ruby
iptables_ng_chain 'CUSTOM'
iptables_ng_rule 'rule-using-custom-chain'
```

This release also fixes a bug previously introduced by trying to workaround the
cloning issues, where a chain policy wasn't properly updated. See [this
issue](https://github.com/chr4-cookbooks/iptables-ng/issues/63) for details.

2.3.1
-----

- Add compatibility fix for older chef-clients

2.3.0
-----

- Add workarounds for duplicate resource warnings

2.2.11
------

- Add compatibility setting for `source_url` attribute in `metadata.rb`

2.2.10
------

- Revert `use_inline_resources`, was causing trouble

2.2.9 (broken, do not use!)
-----

- Fix code linting complaints (rubocop, foodcritc)
- Add `use_inline_resources` to providers

2.2.8
-----

- Add `node['iptables-ng']['auto_prune_attribute_rules']` attribute to remove unused/ old rules created by attributes automatically

2.2.7
-----

- Add support for Debian Jessie

2.2.6
-----

- Add possibility to disable the reload or restore of iptables at the end of a chef run

2.2.5
-----

- Only install `iptables` package on Amazon Linux

2.2.4
-----

- Check whether name attribute in rule provider is valid
- Fix an issue with resource notification in rule provider
- Fix an issue with nat table on ipv6 not properly skipped on systems without ip6tables nat support
- Add `node['iptables-ng']['ip6tables_nat_support']` attribute, default to true on recent Ubuntu
  versions

2.2.3
-----

- Add posibility to add an "action" when configuring iptables rules via attributes. See README for
  details

2.2.2
-----

- Fix an issue with init-script name on Ubuntu >= 14.10 (was renamed to netfilter-persistent)

2.2.1
-----

- Add support for RHEL 7 compatible distributions


2.2.0
-----

- Add support for `node['iptables-ng']['enabled_tables']`


2.1.1
-----

- Fix an issue with `node['iptables-ng']['enabled_ip_versions']`, Thanks [Bob Ziuchkovski](https://github.com/ziuchkovski)
- Add Travis with rubocup and foodcritic checks

2.1.0
-----

- Add rubocup
- Add attribute `node['iptables-ng']['enabled_ip_versions']`


2.0.0
-----

- Support custom chains
- Rename/Migrate iptables\_ng\_policy provider to iptables\_ng\_chain

1.1.1
-----

- Fixes duplicate resource name warnings [CHEF-3694], Thanks [James FitzGibbon](http://github.com/jf647)

1.1.0
-----

- Support for ip\_version parameter in attributes. See README for details.

  If you use attributes to configure iptables\_ng, you need to migrate

  ```node['iptables-ng']['rules']['filter']['INPUT']['rej'] = 'myrule'```

  to

  ```node['iptables-ng']['rules']['filter']['INPUT']['rej']['rule'] = 'myrule'```


1.0.0
-----
- [Chris Aumann] - Initial release of iptables-ng
