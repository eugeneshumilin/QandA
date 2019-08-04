require 'rails_helper'

feature 'User can delete links', %q{
  In order to delete links from answer
  user as an author of qanswer
  can delete own links
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_answer) { create(:answer, question: question, user: user) }
  given!(:link) { create(:link, linkable: answer) }
  given!(:gist_link) { create(:link, :gist_link, linkable: another_answer) }
  given!(:gist_content) { 'Hello Thinknetica!' }

  describe 'authenticated user', js: true do
    scenario 'author of answer tries to delete links' do
      sign_in(user)
      visit question_path(question)

      within ".delete-link-#{link.id}" do
        click_on 'remove'
      end

      within ".answer-#{answer.id}" do
        expect(page).to_not have_link link.url
      end
    end

    scenario 'author of answer tries to delete gist link' do
      sign_in(user)
      visit question_path(question)

      within ".delete-link-#{gist_link.id}" do
        click_on 'remove'
      end

      within ".answer-#{another_answer.id}" do
        expect(page).to_not have_content gist_content
      end
    end

    scenario 'another user tries to delete links' do
      sign_in(another_user)
      visit question_path(question)

      within ".answer-#{answer.id}" do
        expect(page).to_not have_link 'remove'
      end
    end
  end

  scenario 'unauthenticated user tries to delete links' do
    visit question_path(question)

    within ".answer-#{answer.id}" do
      expect(page).to_not have_link 'remove'
    end
  end
end