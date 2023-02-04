class AddPipelineToItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :items, :pipeline, foreign_key: true

    items = Item.all.reject(&:save)
    items.each(&:destroy)

    change_column_null :items, :pipeline_id, false
  end
end
