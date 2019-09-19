class FileSerializer < ActiveModel::Serializer
  attributes :id, :filename, :url_link

  def file_id
    object.blob.id
  end

  def filename
    object.blob.filename
  end

  def url_link
    'object.blob.url'
  end
end
