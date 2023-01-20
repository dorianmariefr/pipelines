class SourcesController < ApplicationController
  def preview
    @source = authorize Source.new(source_params)

    render json: @source.preview
  end

  private

  def source_params
    params.require(:source).permit(
      :kind,
      :filter,
      parameters_attributes: %i[key value]
    )
  end
end
