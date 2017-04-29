class AddCurrentStepToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :form_submission_started, :boolean, default: false
  end
end
