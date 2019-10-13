class AddPopulationToLog < ActiveRecord::Migration[5.2]
  def change
		add_column :logs, :population_id, :integer
  end
end
