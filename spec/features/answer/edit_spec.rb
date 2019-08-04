require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  as an author of answer
  i'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link('edit')
  end

  describe 'Authenticated user', js: true do
    scenario 'tries to edit his own answer' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Body', with: 'Edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to add files when edit his own answer' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'tries to edit answer with errors' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit another user's answer" do
      sign_in(another_user)
      visit question_path(question)

      expect(page).to_not have_content 'Edit'
    end

    scenario 'tries to edit own answer by adding a link' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        click_on 'add link'

        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: 'http://google.com'

        click_on 'Save'

        expect(page).to have_link 'Google', href: 'http://google.com'
        expect(page).to_not have_selector 'textfield'
      end
    end
  end
end
