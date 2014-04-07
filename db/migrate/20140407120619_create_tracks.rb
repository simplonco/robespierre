class CreateTracks < ActiveRecord::Migration
	def change
		create_table :tracks do |t|
			t.string 	:title
			t.string 	:lien
			t.integer	:position    
		end
	end
end
