require 'rails_helper'

feature 'Author can remove files from his own answer', '
  In order to remove unnecessary files
  from his own answer
  Author can delete files
' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_answer) { create(:answer, question: question, user: another_user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      attach_file_to(answer)
      attach_file_to(another_answer)
      answer.reload
      another_answer.reload
      visit question_path(question)
    end

    scenario "delete author's file from his own answer" do
      within ".attachment-#{answer.files.first.id}" do
        click_on 'Remove file'
      end

      within ".answer-#{answer.id}" do
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario "delete another user's answer" do
      within ".answer-#{another_answer.id}" do
        expect(page).to_not have_link 'Remove file'
      end
    end
  end

  scenario 'unauthenticated user tries to delete answer', js: true do
    attach_file_to(answer)
    answer.reload
    visit question_path(question)
    within ".answer-#{answer.id}" do
      expect(page).to_not have_link 'Remove file'
    end
  end
end
