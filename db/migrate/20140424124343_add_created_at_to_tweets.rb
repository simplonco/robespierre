class AddCreatedAtToTweets < ActiveRecord::Migration
  def change
  	add_column :tweets, :created_at, :time
  end
end
