class CreateNps < ActiveRecord::Migration[5.1]
  def change
    create_table :nps do |t|
      t.integer :score
      t.string :touchpoint
      t.timestamps
    end
  end
end
