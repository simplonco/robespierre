class AddPositionIndexToTrack < ActiveRecord::Migration
  def change
  	add_index :tracks, :position, order: :asc
  end
end
