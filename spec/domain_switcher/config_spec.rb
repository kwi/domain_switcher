require 'spec_helper'

describe :config_loader do

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
  
  it "load correctly the config" do
    config = DomainSwitcher::ConfigLoader.new(File.join(File.dirname(__FILE__), '../config/websites.yml'))
  end  
end