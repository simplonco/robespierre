
module ArgsParser
  class Parser

    def parse_style_default(argv)
      k = nil
      is_key = /^-+([^-\s]+)$/
      argv.each_with_index do |arg, index|
        unless k
          if arg =~ is_key
            k = arg.scan(is_key)[0][0].strip.to_sym
            k = aliases[k]  if aliases[k]
          else
            @argv.push arg
          end
        else
          if arg =~ is_key
            params[k][:value] = true
            k = arg.scan(is_key)[0][0].strip.to_sym
            k = aliases[k]  if aliases[k]
          else
            params[k][:value] = arg
            k = nil
          end
        end
      end
      if k
        params[k][:value] = true
      end
    end

  end
end
