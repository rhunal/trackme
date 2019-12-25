class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.string :name
      t.index ["name"], name: "index_countries_on_name", unique: true

      t.timestamps
    end
  end
end
