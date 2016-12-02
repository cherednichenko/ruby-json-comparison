# Controller responsible for handling all requests
class V1::DiffsController < ApplicationController

  # For skipping the following warning/error
  # Can't verify CSRF token authenticity.
  skip_before_action :verify_authenticity_token
  before_action :set_v1_diff

  # Storing left content to be compared
  # An example on how to call this method using curl is below:
  # curl -X POST --data-binary "@left.json" http://localhost:3003/v1/diff/1/left
  def left
    @v1_diff.left = Base64.decode64(request.body.string)
    @v1_diff.save
    head :ok
  end

  # Storing right content to be compared.
  # An example on how to call this method using curl is below:
  # curl -X POST --data-binary "@right.json" http://localhost:3003/v1/diff/1/right
  def right
    @v1_diff.right = Base64.decode64(request.body.string)
    @v1_diff.save
    head :ok
  end

  # Retrieving diff results
  # An example on how to call this method using curl is below:
  # curl -X GET http://localhost:3003/v1/diff/1
  def show
    render json: { jsons_comparison_result: @v1_diff.jsons_comparison }
  end

  private

  def set_v1_diff
    @v1_diff = V1::Diff.find(params[:id])
  rescue => e
    @v1_diff = V1::Diff.new(id: params[:id])
  end
end
