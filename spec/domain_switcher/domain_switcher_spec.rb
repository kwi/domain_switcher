require 'spec_helper'

describe :domain_switcher do

  before :all do
    @conf = DomainSwitcher::ConfigLoader.new(File.join(File.dirname(__FILE__), '../config/websites.yml'))
    @app = DomainSwitcher::Middleware.new(Proc.new {|b| [200, 'OK']}, @conf)
  end

  it "not create a new memcache connection if namespace is the same" do
    @app.call({'HTTP_HOST' => 'www.website1.com', 'rack.session.options' => {:domain => :test, :something => true}})
    Thread.current[:domain_switcher_cache].instance_variable_get('@data') == RAILS_CACHE
  end
  
  it "switch on default when nothing is found" do
    @app.call({'HTTP_HOST' => 'nothing', 'rack.session.options' => {:domain => :test, :something => true}})
    Thread.current[:domain_switcher_domain].should == @conf.default_domain
    Thread.current[:domain_switcher_website].should == @conf.default_website
  end

  it "correctly switch" do
    @app.call({'HTTP_HOST' => 'www.website1.com', 'rack.session.options' => {:domain => :test, :something => true}})
    Thread.current[:domain_switcher_domain].domain.should == 'www.website1.com'
    Thread.current[:domain_switcher_website].symbol.should == 'website1'
  end

  it "correctly switch the cookie domain" do
    env = {'HTTP_HOST' => 'www.website1.com', 'rack.session.options' => {:domain => :test, :something => true}}
    @app.call(env)
    env['rack.session.options'][:domain].should == 'website1.com'
  end

  it "correctly switch the cache namespace" do
    @app.call({'HTTP_HOST' => 'www.website1.com', 'rack.session.options' => {:domain => :test, :something => true}})
    Rails.cache.instance_variable_get('@data').prefix_key.should == 'first'
    @app.call({'HTTP_HOST' => 'www.website2.com', 'rack.session.options' => {:domain => :test, :something => true}})
    Rails.cache.instance_variable_get('@data').prefix_key.should == 'website2'
    @app.call({'HTTP_HOST' => 'www.website1.com', 'rack.session.options' => {:domain => :test, :something => true}})
    Rails.cache.instance_variable_get('@data').prefix_key.should == 'first'
  end


end