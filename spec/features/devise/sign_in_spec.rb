require 'rails_helper'

feature 'user can sign in', "
  In order to ask question
  as unauthenticated user
  i'd like to be able sign in
" do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
