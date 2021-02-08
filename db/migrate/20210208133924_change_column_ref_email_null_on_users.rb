class ChangeColumnRefEmailNullOnUsers < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :ref_email, true
  end
end
