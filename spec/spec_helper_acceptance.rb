require 'beaker-rspec'

hosts.each do |host|
  # Install Puppet
  install_puppet
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation
  c.add_setting :test_compat
  c.test_compat = ENV['BEAKER_test_compat'] || 'no'

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    if c.test_compat == 'no'
      puppet_module_install(:source => proj_root, :module_name => 'repo_centos')
    end

    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
    end
  end
end