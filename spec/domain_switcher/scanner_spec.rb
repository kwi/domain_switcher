require 'spec_helper'

describe :scanner do
  
  before :all do
    @config = DomainSwitcher::ConfigLoader.new(File.join(File.dirname(__FILE__), '../config/websites.yml'))
    @scanner = DomainSwitcher::Scanner.new(@config.domains)
  end
  
  it "return nil when not existing" do
    @scanner.scan_domain(nil).should == nil
    @scanner.scan_domain('something_not_existing').should == nil
  end

  it "return correct domain when existing" do
    @scanner.scan_domain('www.website2.com').should_not be_nil
    @scanner.scan_domain('www.website2.com').domain == 'www.website2.com'
    @scanner.scan_domain('fr.website2.com').domain == 'fr.website2.com'
    @scanner.scan_domain('www.website1-other-domain-again.com').domain == 'www.website1-other-domain-again.com'
    @scanner.scan_domain('www.website1.com').domain == 'www.website1.com'
  end

end