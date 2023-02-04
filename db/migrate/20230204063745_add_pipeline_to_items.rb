class AddPipelineToItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :items, :pipeline, foreign_key: true

    Item.find_each(&:save!)

    change_column_null :items, :pipeline_id, false
  end
end
