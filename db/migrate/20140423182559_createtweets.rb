class Createtweets < ActiveRecord::Migration
	def change
		create_table :tweets do |t|
			t.string 	:author_name
			t.string 	:content
		end
	end
end
