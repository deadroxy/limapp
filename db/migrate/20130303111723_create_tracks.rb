class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string :album_name
      t.string :artist
      t.string :title
      t.integer :year
      t.integer :month 
      t.string :spotify_href
      t.float :popularity
      
      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
