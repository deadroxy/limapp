class CreateSoundtracks < ActiveRecord::Migration
  def self.up
    create_table :soundtracks do |t|
      t.integer  :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :soundtracks
  end
end
