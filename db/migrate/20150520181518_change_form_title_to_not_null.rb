class ChangeFormTitleToNotNull < ActiveRecord::Migration
  def change
    change_column_null(:forms, :title, true)
  end
end
