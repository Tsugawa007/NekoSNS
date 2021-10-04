class AddPostImage < ActiveRecord::Migration[6.1]
  def change
    add_column :posts,:post_name,:string
  end
end
