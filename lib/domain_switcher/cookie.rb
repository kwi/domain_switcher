module DomainSwitcher
  module Cookie
    
    def self.switch(domain, env)
      env['rack.session.options'].update(:domain => domain.cookie_domain)
      env
    end

  end
end