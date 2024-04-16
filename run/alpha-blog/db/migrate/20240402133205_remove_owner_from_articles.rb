class RemoveOwnerFromArticles < ActiveRecord::Migration[7.1]
  def change
    remove_column :articles, :owner
  end
end
