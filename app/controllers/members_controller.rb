class MembersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def show
    render json: { message: "If you see this, you're in!" }
  end
end
