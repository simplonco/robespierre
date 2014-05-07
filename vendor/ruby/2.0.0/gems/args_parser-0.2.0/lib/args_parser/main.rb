module ArgsParser

  def self.parse(argv=[], config={}, &block)
    Config::DEFAULT.each do |k,v|
      config[k] = v unless config[k]
    end
    parser = Parser.new(config, &block)
    parser.parse argv
    parser
  end

end
