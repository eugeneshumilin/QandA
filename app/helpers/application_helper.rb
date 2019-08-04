module ApplicationHelper

  FLASH_TYPE = { alert: 'danger', notice: 'primary' }.freeze

  def flash_selector(type)
    FLASH_TYPE[type.to_sym] || type
  end
end
