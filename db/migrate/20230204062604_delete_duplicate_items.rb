class DeleteDuplicateItems < ActiveRecord::Migration[7.0]
  def change
    Item
      .preload(:pipeline)
      .group_by { |item| [item.external_id, item.pipeline.id] }
      .each { |_, items| items[1..].each(&:destroy) }
  end
end
