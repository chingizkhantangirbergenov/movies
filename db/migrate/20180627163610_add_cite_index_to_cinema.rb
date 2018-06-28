class AddCiteIndexToCinema < ActiveRecord::Migration[5.2]
  def change
    add_column :cinemas, :cite_index, :integer
  end
end
