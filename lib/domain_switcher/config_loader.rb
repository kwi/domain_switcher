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
      raise ArgumentError.new("DomainSwitcher: Empty config file (#{config_file})") if !@conf or @conf.size == 0

      @websites = []
      @domains = []
      parse_conf!      
    end
    
  private
    def parse_conf!
      @conf.each do |website, conf|
        domains = conf.delete('domains')
        default_domain = conf.delete('default_domain')
        raise "DomainSwitcher: Website without domain: #{website}" if !domains or domains.size == 0
        raise "DomainSwitcher: Website without default domain: #{website}" if !default_domain
        
        website = Website.new(conf['name'], website, conf)
        
        domains.each do |d|
          if String === d
            website << Domain.new(website, d, conf.merge(conf))
          else # It's an hash like this: {"www.website1.com"=>{"name"=>"Website 1 override", "width"=>900}}
            raise "DomainSwitcher: Bad indentation in the config file" if d.size != 1
            website << Domain.new(website, d.first.first, d.first.last.merge(conf))
          end
        end

        # Set the default domain for the website
        website.default_domain = website.domains.find {|d| d.domain == default_domain } || website.domains.first

        # Collect websites and domains
        @websites << website
        @domains += website.domains
      end      
    end

  public
    def default_website
      @default_website ||= @websites.find { |w| w.default? } || @websites.first
    end

    def default_domain
      @default_domain ||= @domains.find { |d| d.default? } || @domains.first
    end    
  end
end