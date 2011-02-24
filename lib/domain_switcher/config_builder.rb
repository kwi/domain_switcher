module DomainSwitcher
  module ConfigBuilder

    # Create a bunch of method for the configuration hash
    def build_config!(hash)
      raise "Build config only accept hashes and not #{conf.class}" unless Hash === hash
      
      # From: https://github.com/kwi/awesome_conf
      m = Module.new do
        instance_methods.each { |selector| remove_method(selector) }

        hash.each do |k, v|
          const_set('AC_' + k.to_s, v)
          module_eval <<-END_EVAL, __FILE__, __LINE__ + 1
            def #{k}
              #{'AC_'+ k.to_s}
            end
          END_EVAL
          
          if TrueClass === v or FalseClass === v
            module_eval <<-END_EVAL, __FILE__, __LINE__ + 1
              def #{k}?
                #{v ? true : false}
              end
            END_EVAL
          end
        end

      end

      extend m
    end

    # Do nothing when a method is missing
    def method_missing(m)
      nil
    end

  end  
end