require 'rails_helper'

feature 'authenticated user can sign out', '
  In order to log out
  as authenticated user
  i want to be able to sign out
' do
  given(:user) { create(:user) }

  scenario 'authenticated user tries sign out' do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
