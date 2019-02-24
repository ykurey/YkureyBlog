class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :author
      t.string :tag
      t.datetime :pentime
      t.text :context

      t.timestamps
    end
  end
end
