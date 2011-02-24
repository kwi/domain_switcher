require 'spec_helper'

describe :config_loader do

  context "With incorrect conf file" do
    it "Raise correctly on empty" do
      e = nil
      begin
        DomainSwitcher::ConfigLoader.new(File.join(File.dirname(__FILE__), '../config/websites_empty.yml'))
      rescue Exception => e
      end
      e.to_s.index('DomainSwitcher: Empty config file').should_not be_nil
    end

    it "Raise correctly on not found config file" do
      e = nil
      begin
        DomainSwitcher::ConfigLoader.new(File.join(File.dirname(__FILE__), '../config/websites_not_existing.yml'))
      rescue Exception => e
      end
      e.to_s.index('No such file or directory').should_not be_nil
    end

    it "Raise correctly on malformed config file" do
      e = nil
      begin
        DomainSwitcher::ConfigLoader.new(File.join(File.dirname(__FILE__), '../config/websites_broken.yml'))
      rescue ArgumentError => e
      end
      e.to_s.index('DomainSwitcher: Malformed config file').should_not be_nil
    end
    
    it "Raise correctly on bad indentation config file" do
      e = nil
      begin
        DomainSwitcher::ConfigLoader.new(File.join(File.dirname(__FILE__), '../config/websites_bad_indentation.yml'))
      rescue Exception => e
      end
      e.to_s.index('DomainSwitcher: Bad indentation in the config file').should_not be_nil
    end
  end
  
  context 'With a correct file' do
    before :all do
      @config = DomainSwitcher::ConfigLoader.new(File.join(File.dirname(__FILE__), '../config/websites.yml'))
    end
    
    it "load correctly all domains" do
      @config.domains.size.should == 6
      @config.domains.collect(&:domain).uniq.size.should == 6
      @config.domains.first.domain.should == 'www.website1.com'
    end

    it "load correctly all websites" do
      @config.websites.size.should == 2
      @config.websites.collect(&:symbol).uniq.size.should == 2
      @config.websites.first.symbol.should == 'website1'
    end

    it "set correctly default domain" do
      @config.websites[0].default_domain.domain.should == 'www.website1.com'
      @config.websites[1].default_domain.domain.should == 'fr.website2.com'
      @config.default_domain.domain.should == 'www.website2.com'
    end

    it "set correctly default website" do
      @config.default_website.symbol.should == 'website2'
    end

    it "conf variables are well set" do
      @config.default_website.name.should == 'Website2'
      @config.default_website.default.should == true
      @config.default_website.lang.should == 'fr'
    end

    it "boolean conf variables are well set" do
      @config.default_website.default?.should == true
      @config.default_website.false_meth?.should == false
    end
    
    it "cookie domain can be overrided" do
      @config.default_domain.cookie_domain.should == 'website2cookie.com'
    end

  end
end