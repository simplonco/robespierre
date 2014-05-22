def no_special_caracters(input)
		input = input.gsub("&", "et ").
		gsub("@", "at ").
		gsub("#", "hachetague").
		gsub(/[$°_\"{}\]\[`~&+,:;=?@#|'<>.^*()%!-]/, "")
end