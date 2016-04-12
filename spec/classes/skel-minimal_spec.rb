require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'removecontent' do

  let(:title) { 'removecontent' }
  let(:node) { 'rspec.get-automation.com' }
  let(:facts) { { :ipaddress => '10.21.21.21' } }
  let(:facts) { { :operatingsystem => 'RedHat'} }

  describe 'Test minimal installation' do
    it { should contain_package('removecontent.package').with_ensure('present') }
    it { should contain_file('removecontent.conf').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.6.21' } }
    it { should contain_package('removecontent.package').with_ensure('1.6.21') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true } }
    it 'should remove Package[removecontent]' do should contain_package('removecontent.package').with_ensure('absent') end 
    it 'should remove removecontent configuration file' do should contain_file('removecontent.conf').with_ensure('absent') end
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true} }
    it { should contain_package('removecontent.package').with_noop('true') }
    it { should contain_file('removecontent.conf').with_noop('true') }
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "removecontent/spec.erb" , :options => { 'opt_a' => 'value_a' } } }
    it 'should generate a valid template' do
      should contain_file('removecontent.conf').with_content(/rspec.get-automation.com/)
    end
    it 'should generate a template that uses custom options' do
      should contain_file('removecontent.conf').with_content(/value_a/)
    end
  end

  describe 'Test customizations - source' do
    let(:params) { {:source => 'puppet:///modules/removecontent/spec'} }
    it { should contain_file('removecontent.conf').with_source('puppet:///modules/removecontent/spec') }
  end

  describe 'Test customizations - source_dir' do
    let(:params) { {:source_dir => "puppet:///modules/removecontent/dir/spec" , :source_dir_purge => true } }
    it { should contain_file('removecontent.dir').with_source('puppet:///modules/removecontent/dir/spec') }
    it { should contain_file('removecontent.dir').with_purge('true') }
    it { should contain_file('removecontent.dir').with_force('true') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:extend => "removecontent::spec" } }
    it { should contain_file('removecontent.conf').with_content(/rspec.get-automation.com/) }
  end

end
