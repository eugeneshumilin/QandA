require 'rails_helper'

feature 'user can create answer', '
  In order to help people
  authenticated user can create answer
' do
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
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Reply'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    context 'mulitple sessions', js: true do
      given(:some_url) { 'https://google.com' }

      scenario "question appears on another user's page" do
        Capybara.using_session('another_user') do
          another_user = create(:user)

          sign_in(another_user)
          visit question_path(question)
        end

        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)

          fill_in 'Body', with: 'answer body'

          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

          fill_in 'Link name', with: 'My link'
          fill_in 'Url', with: some_url

          click_on 'Reply'

          expect(page).to have_content 'answer body'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end

        Capybara.using_session('another_user') do
          expect(page).to have_content 'answer body'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
          expect(page).to have_link 'My link', href: some_url
        end
      end
    end
  end

  scenario 'unathenticated user tries to create answer' do
    visit question_path(question)
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
