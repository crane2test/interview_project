class AddLabelToLog < ActiveRecord::Migration[5.2]
  def change
		add_column :logs, :label, :string
  end
end
