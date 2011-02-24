require 'yaml'

module DomainSwitcher
  class ConfigLoader
    
    attr_reader :websites
    attr_reader :domains

    def initialize(config_file = 'config/websites.yml')
      begin
        @conf = YAML::load_file(config_file)
      rescue ArgumentError => e
        raise ArgumentError.new("DomainSwitcher: Malformed config file (#{config_file}): #{e}")
      end
      raise ArgumentError.new("DomainSwitcher: Empty config file (#{config_file})") if !@conf or @conf.empty?

      parse_conf!
    end
    
  private
    def parse_conf!
      @conf.each do |website, conf|
        domains = conf.delete(:domains)
        default_domain = conf.delete(:default_domain)
        raise "DomainSwitcher: Website without domain: #{website}" if domains.empty?
        raise "DomainSwitcher: Website without default domain: #{website}" if default_domain.empty?
        
        website = Website.new(conf['name'], website, conf)
        
        domains.each do |d|
          puts d.class
          if String === d
            website << Domain.new(website, d, conf)
          else
            website << Domain.new(website, d, )
          end
        end
          
      end
    end
    
  public
    def default_website
    end
    
    def default_domain
    end
    
  end
end