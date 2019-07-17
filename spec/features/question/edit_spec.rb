require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  as an author of question
  i'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user can not edit question' do
    visit questions_path

    expect(page).to_not have_link('edit')
  end

  describe 'Authenticated user', js: true do
    scenario 'tries to edit his own question' do
      sign_in(user)
      visit questions_path

      click_on 'Edit'

      within '.questions' do
        fill_in 'Title', with: 'Edited title'
        fill_in 'Body', with: 'Edited body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited title'
        expect(page).to have_content 'Edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to add files to his own question' do
      sign_in(user)
      visit questions_path

      click_on 'Edit'

      within '.questions' do
        fill_in 'Title', with: 'Edited title'
        fill_in 'Body', with: 'Edited body'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb" ]

        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'tries to edit question with errors' do
      sign_in(user)
      visit questions_path

      click_on 'Edit'

      within '.questions' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit another user's question" do
      sign_in(another_user)
      visit questions_path

      expect(page).to_not have_content 'Edit'
    end
  end
end