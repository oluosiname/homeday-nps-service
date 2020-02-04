class AddRespondentANdObjectToNps < ActiveRecord::Migration[5.1]
  def change
    add_column :nps, :respondent_id, :integer
    add_column :nps, :respondent_class, :string
    add_column :nps, :object_id, :integer
    add_column :nps, :object_class, :string
    add_index :nps, [:score, :respondent_id, :respondent_class, :object_id, :object_class, :touchpoint], unique: true, name: 'index_nps_on_respondent_and_object'
  end
end
