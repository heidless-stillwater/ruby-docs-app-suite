class AddOwnerToArticles < ActiveRecord::Migration[7.1]
  def change
    add_column :articles, :owner, :string
  end
end
