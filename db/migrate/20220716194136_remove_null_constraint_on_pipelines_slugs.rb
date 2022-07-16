class RemoveNullConstraintOnPipelinesSlugs < ActiveRecord::Migration[7.0]
  def change
    change_column_null :pipelines, :slug, true
  end
end
