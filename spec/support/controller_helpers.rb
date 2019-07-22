module ControllerHelpers
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end

  def attach_file_to(receiver)
    receiver.files.attach(io: File.open("#{Rails.root.join('spec/rails_helper.rb')}"), filename: 'rails_helper.rb')
  end
end