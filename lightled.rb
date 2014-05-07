#test pour faire fonctionner un arduino à partir de l'app
require 'arduino_firmata'

class ArduinoControl

	def initialize(device_name, *args)
		@device_name = device_name
		@connexion = ArduinoFirmata.connect
	end

	def lightled()
		for i in 0..5 do 
			@connexion.digital_write 13, true
			sleep 0.5
			@connexion.digital_write 13, false
			sleep 0.5
		end
		@connexion.close
	end

	def blink_ten_times(pause)
		puts 5.times {
			@connexion.digital_write 13, true
			sleep(pause)
			@connexion.digital_write 13, false
			sleep(pause)
		}
		@connexion.close
	end

end
