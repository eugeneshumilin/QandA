require 'rails_helper'

feature 'user can create question', %q{
  In order to solve problem
  authenticated user can ask question
} do
  given(:user) { create(:user) }

  describe  do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'authenticated user tries to create question with valid attributes' do
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Question title'
      expect(page).to have_content 'Question body'
    end

    scenario 'user tries to create question with in-valid attributes' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'unauthenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end