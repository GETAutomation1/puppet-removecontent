# Acceptance Tests for removecontent
# README:
# Unlike the unit tests which only test compilation and a puppet run,
# they do not cover a more real world scenario. As such you cannot 
# pass bogus information into the parameters or versions
require 'spec_helper_acceptance'

# This should reflect what you have in params.pp
# Meaning these should be REAL values.
case fact('operatingsystem')
  when /(?i:RedHat|OracleLinux|CentOS)/
    enforced_package                     = 'removecontent'
    enforced_package_version             = '5.5'
    enforced_config_file                 = '/etc/removecontent/removecontent.conf'
    enforced_custom_config_file_source   = 'puppet:///modules/removecontent/spec'
    enforced_custom_config_file_template = 'removecontent/spec.erb'
end


# Standard Installation, accepting default options
describe 'removecontent Class - Standard Installation' do
  it 'Should run successfully, even on successive runs' do
    pp = <<-EOS
    class { 'removecontent': }
    EOS
    expect(apply_manifest(pp).exit_code).to_not eq(1)
    expect(apply_manifest(pp).exit_code).to eq(0)
  end

  describe package("#{enforced_package}") do
    it { should be_installed }
  end

  describe file("#{enforced_config_file}") do
    it { should be_file }
  end

end

# Standard Installation, Specific Version Required
describe 'removecontent Class - Installation of a specific verion' do
  it 'Should run successfully, even on successive runs' do
    pp = <<-EOS
    class { 'removecontent': 
      version => "#{enforced_package_version}"
    }
    EOS
    expect(apply_manifest(pp).exit_code).to_not eq(1)
    expect(apply_manifest(pp).exit_code).to eq(0)
  end

  describe package("#{enforced_package}") do
    it { should be_installed.with_version("#{enforced_package_version}") }
  end

  describe file("#{enforced_config_file}") do
    it { should be_file }
  end

end

# Standard Installtion with a custom source provided
describe 'removecontent Class - Installation with a custom source' do
  it 'Should run successfully, even on successive runs' do
    pp = <<-EOS
    class { 'removecontent': 
      source => "#{enforced_custom_config_file_source}"
    }
    EOS
    expect(apply_manifest(pp).exit_code).to_not eq(1)
    expect(apply_manifest(pp).exit_code).to eq(0)
  end

  describe package("#{enforced_package}") do
    it { should be_installed }
  end

  describe file("#{enforced_config_file}") do
    it { should be_file }
  end

end

# Standard Installation with a custom template provided
describe 'removecontent Class - Installation with a custom template' do
  it 'Should run successfully, even on successive runs' do
    pp = <<-EOS
    class { 'removecontent': 
      template => "#{enforced_custom_config_file_template}",
      options => { 'opt_a' => 'value_a' }
    }
    EOS
    expect(apply_manifest(pp).exit_code).to_not eq(1)
    expect(apply_manifest(pp).exit_code).to eq(0)
  end

  describe package("#{enforced_package}") do
    it { should be_installed }
  end

  describe file("#{enforced_config_file}") do
    it { should be_file}
    it { should contain 'value_a' }
  end

end
