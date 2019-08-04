module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def attach_file_to(receiver)
    receiver.files.attach(io: File.open(Rails.root.join('spec/rails_helper.rb').to_s), filename: 'rails_helper.rb')
  end

  def add_image_to(badge)
    badge.image.attach(
      io: File.open(Rails.root.join('public/apple-touch-icon.png').to_s),
      filename: 'apple-touch-icon.png'
    )
  end
end
