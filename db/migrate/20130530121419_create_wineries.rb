class CreateWineries < ActiveRecord::Migration
  def change
    create_table :wineries do |t|
      t.string :country
      t.boolean :tasting_room
    end
  end
end
