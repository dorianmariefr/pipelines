class UpdateAllSourceFilterTypeToCode < ActiveRecord::Migration[7.0]
  def change
    Source.update_all(filter_type: :code)
  end
end
