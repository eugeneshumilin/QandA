class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_link

  def destroy
    if current_user.author_of?(@link.linkable)
      @link.destroy
    else
      redirect_to @link.linkable
    end
  end

  private

  def find_link
    @link = Link.find(params[:id])
  end
end
