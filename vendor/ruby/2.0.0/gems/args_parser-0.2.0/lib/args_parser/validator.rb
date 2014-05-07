module ArgsParser
  class Validator

    attr_reader :validators

    def initialize
      @validators = []
    end

    def add(name, message, validator)
      name = name.to_sym if name
      validators.push({:name => name, :message => message, :validator => validator})
    end

    def validate(name, value)
      validators.each do |f|
        if !f[:name] or f[:name] == name
          return f[:message] unless f[:validator].call(value)
        end
      end
      nil
    end
  end
end
