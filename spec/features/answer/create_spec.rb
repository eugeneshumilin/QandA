require 'rails_helper'

feature 'user can create answer', %q{
  In order to help people
  authenticated user can create answer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'authenticated user creates answer', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to create answer with valid attributes', js: true do
      fill_in 'Body', with: 'Test answer'
      click_on 'Reply'

      expect(page).to have_content 'Test answer'
    end

    scenario 'tries to create answer with in-valid attributes' do
      click_on 'Reply'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to create answer with attached files' do
      fill_in 'Body', with: 'Test answer'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb" ]
      click_on 'Reply'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'unathenticated user tries to create answer' do
    visit question_path(question)
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end