class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment

  def destroy
    if current_user.author_of?(@attachment.record)
      @attachment.purge
    else
      redirect_to @attachment.record
    end
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end