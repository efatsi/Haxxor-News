class ChangeArticlePointDefault < ActiveRecord::Migration
  def change
    change_column_default(:articles, :points, 0)
  end
end
