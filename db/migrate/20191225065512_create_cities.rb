class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :country_name
      t.index ["name"], name: "index_cities_on_name", unique: true

      t.timestamps
    end
  end
end
