require 'rails_helper'

feature 'user can create answer', %q{
  In order to help people
  authenticated user can create answer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe  do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'authenticated user tries to create answer with valid attributes' do
      fill_in 'Body', with: 'Test answer'
      click_on 'Reply'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Test answer'
    end

    scenario 'authenticated user tries to create answer with in-valid attributes' do
      click_on 'Reply'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'unathenticated user tries to create answer' do
    visit question_path(question)
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end