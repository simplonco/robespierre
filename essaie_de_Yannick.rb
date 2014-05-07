
puts "coucou"
entry = ""

loop do
	entry  =gets.strip
	puts "entry: #{entry}"
	if entry == "quit"
		exit(0)
	end
	sleep(2)
end