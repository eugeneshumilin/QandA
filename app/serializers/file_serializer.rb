class FileSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :filename, :file_url

  def file_id
    object.blob.id
  end

  def filename
    object.blob.filename
  end

  def file_url
    rails_blob_path(object, host: 'http://127.0.0.1:3000')
  end
end
