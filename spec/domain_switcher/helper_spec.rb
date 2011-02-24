require 'spec_helper'

describe :helper do

  before :all do
    @conf = DomainSwitcher::ConfigLoader.new(File.join(File.dirname(__FILE__), '../config/websites.yml'))
    @app = DomainSwitcher::Middleware.new(Proc.new {|b| [200, 'OK']}, @conf)
  end

  it "Check helper" do
    @app.call({'HTTP_HOST' => 'www.website1.com', 'rack.session.options' => {:domain => :test, :something => true}})
    ActionController::Base.new.website.symbol.should == 'website1'
    ActionController::Base.new.website.should == Thread.current[:domain_switcher_website]
    ActionController::Base.new.domain.should == Thread.current[:domain_switcher_domain]
    
    @app.call({'HTTP_HOST' => 'www.website2.com', 'rack.session.options' => {:domain => :test, :something => true}})
    ActionController::Base.new.website.symbol.should == 'website2'
    ActionController::Base.new.website.should == Thread.current[:domain_switcher_website]
    ActionController::Base.new.domain.should == Thread.current[:domain_switcher_domain]
    ActionView::Base.new.website.should == Thread.current[:domain_switcher_website]
    ActiveRecord::Base.new.domain.should == Thread.current[:domain_switcher_domain]    
  end

end