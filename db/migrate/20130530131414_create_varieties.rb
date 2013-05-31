class CreateVarieties < ActiveRecord::Migration
  def change
    create_table :varieties do |t|
      t.integer :winery_id
      t.string :name
    end
  end
end
