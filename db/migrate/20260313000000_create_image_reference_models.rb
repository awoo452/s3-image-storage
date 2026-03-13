class CreateImageReferenceModels < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :image_key
      t.string :image_alt_key
      t.timestamps
    end

    add_index :products, :slug, unique: true

    create_table :people do |t|
      t.string :name, null: false
      t.string :image_key
      t.json :alt_image_keys, default: []
      t.timestamps
    end

    create_table :brag_cards do |t|
      t.string :title, null: false
      t.string :image_key
      t.timestamps
    end
  end
end
