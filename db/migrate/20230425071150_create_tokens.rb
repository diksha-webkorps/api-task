# frozen_string_literal: true

# CreateTokens
class CreateTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens do |t|
      t.bigint :user_id
      t.string :token, default: ''

      t.timestamps
    end
  end
end
