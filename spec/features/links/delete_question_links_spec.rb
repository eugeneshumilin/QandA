require 'rails_helper'

feature 'User can delete links', '
  In order to delete links from question
  user as an author of question
  can delete own links
' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question) }
  given!(:gist_link) { create(:link, :gist_link, linkable: another_question) }
  given!(:gist_content) { 'Hello Thinknetica!' }

  describe 'authenticated user', js: true do
    scenario 'author of question tries to delete links' do
      sign_in(user)
      visit question_path(question)

      within ".delete-link-#{link.id}" do
        click_on 'remove'
      end

      within ".question-#{question.id}" do
        expect(page).to_not have_link link.url
      end
    end

    scenario 'author of question tries to delete gist link' do
      sign_in(user)
      visit question_path(another_question)

      within ".delete-link-#{gist_link.id}" do
        click_on 'remove'
      end

      within ".question-#{another_question.id}" do
        expect(page).to_not have_content gist_content
      end
    end

    scenario 'another user tries to delete links' do
      sign_in(another_user)
      visit question_path(question)

      within ".question-#{question.id}" do
        expect(page).to_not have_link 'remove'
      end
    end
  end

  scenario 'unauthenticated user tries to delete links' do
    visit question_path(question)

    within ".question-#{question.id}" do
      expect(page).to_not have_link 'remove'
    end
  end
end
