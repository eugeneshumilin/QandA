require 'rails_helper'

feature 'User sign up', '
  Is order to be able sign in and ask question
  As an authenticated user
  I want to be able to sign up
' do
  scenario 'Guest try to sign up' do
    visit new_user_registration_path

    fill_in 'Email', with: 'testuser@email.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'

    open_email('testuser@email.com')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content('Your email address has been successfully confirmed.')
  end
end
