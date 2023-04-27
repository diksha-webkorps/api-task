# frozen_string_literal: true

# CreatePages
class CreatePages < ActiveRecord::Migration[6.1]
  def change
    create_table :pages do |t|
      t.string :name
      t.string :description
      t.integer :price

      t.timestamps
    end
  end
end
