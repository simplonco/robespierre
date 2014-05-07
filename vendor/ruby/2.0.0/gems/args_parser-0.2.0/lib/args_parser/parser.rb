module ArgsParser

  class Parser
    attr_reader :argv, :params, :aliases

    public
    def first
      argv.first
    end

    def initialize(config, &block)
      raise ArgumentError, 'initialize block was not given' unless block_given?

      @config = config
      @argv = []
      @params = Hash.new{|h,k|
        h[k] = {
          :default => nil,
          :description => nil,
          :value => nil,
          :alias => nil,
          :index => -1
        }
      }
      @aliases = {}
      @filter = Filter.new
      @validator = Validator.new
      @ons = []

      filter do |v|
        (v.kind_of? String and v =~ /^-?\d+$/) ? v.to_i : v
      end
      filter do |v|
        (v.kind_of? String and v =~ /^-?\d+\.\d+$/) ? v.to_f : v
      end
      on_filter_error do |err, name, value|
        raise err
      end
      on_validate_error do |err, name, value|
        STDERR.puts "Error: #{err.message} (--#{name} #{value})"
        exit 1
      end

      instance_eval &block
    end

    private
    def arg(name, description, opts={})
      name = name.to_sym
      params[name][:default] = opts[:default]
      params[name][:description] = description
      params[name][:index] = params.keys.size
      params[name][:alias] = opts[:alias]
      aliases[opts[:alias]] = name if opts[:alias]
    end

    def filter(name=nil, &block)
      @filter.add name, block if block_given?
    end

    def on_filter_error(err=nil, name=nil, value=nil, &block)
      if block_given?
        @on_filter_error = block
      elsif @on_filter_error.kind_of? Proc
        @on_filter_error.call(err, name, value)
      end
    end

    def validate(name, message, &block)
      @validator.add name, message, block if block_given?
    end

    def on_validate_error(err=nil, name=nil, value=nil, &block)
      if block_given?
        @on_validate_error = block
      elsif @on_validate_error.kind_of? Proc
        @on_validate_error.call(err, name, value)
      end
    end

    def on(name, &block)
      name = name.to_sym
      if block_given?
        @ons.push :name => name, :callback => block
      else
        @ons.each do |event|
          event[:callback].call(self[name]) if event[:name] == name
        end
      end
    end

    def default(key)
      d = params[key.to_sym][:default]
      d.kind_of?(Proc) ? d.call : d
    end

    public
    def args
      params.keys
    end

    def parse(argv)
      send "parse_style_#{@config[:style]}", argv
      params.each do |name, param|
        next if [nil, true].include? param[:value]
        begin
          param[:value] = @filter.filter name, param[:value]
        rescue => e
          on_filter_error e, name, param[:value]
        end
        begin
          msg = @validator.validate name, param[:value]
        rescue => e
          on_validate_error e, name, param[:value]
        end
        if msg
          on_validate_error ValidationError.new(msg), name, param[:value]
        end
      end
      params.keys.each do |name|
        on name if has_option? name or has_param? name
      end
    end

    def [](key)
      params[key.to_sym][:value] || default(key)
    end

    def []=(key, value)
      params[key.to_sym][:value] = value
    end

    def has_option?(*opts)
      !opts.flatten.find{|i| self[i] != true}
    end

    def has_param?(*params)
      !params.flatten.find{|i| self[i] == nil or self[i] == true }
    end

    def inspect
      h = Hash.new
      params.each do |k,v|
        h[k] = v[:value]
      end
      h.inspect
    end

    def help
      params_ = Array.new
      params.each do |k,v|
        v[:name] = k
        params_.push v
      end
      params_ = params_.reject{|i| i[:index] < 0 }.sort{|a,b| a[:index] <=> b[:index] }

      len = params_.map{|i|
        (i[:alias] ?
         " -#{i[:name]} (-#{i[:alias]})" :
         " -#{i[:name]}").size
      }.max

      "options:\n" + params_.map{|i|
        line = (i[:alias] ?
                " -#{i[:name]} (-#{i[:alias]})" :
                " -#{i[:name]}").ljust(len+2)
        line += i[:description].to_s
        line += " : default - #{default i[:name]}" if i[:default]
        line
      }.join("\n")
    end

  end
end
