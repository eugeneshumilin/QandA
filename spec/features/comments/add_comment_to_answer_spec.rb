require 'rails_helper'

feature 'Add comment to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees a new comment link for answer' do
      within ".answer-#{answer.id}" do
        expect(page).to have_link 'New comment'
      end
    end

    scenario 'tries to add new comment to question' do
      within ".answer-#{answer.id}" do
        click_on 'New comment'
        expect(page).to_not have_link 'New comment'

        fill_in 'Comment', with: 'My comment'
        click_on 'Add comment'

        expect(page).to have_content 'My comment'
        expect(page).to have_link 'New comment'
      end
    end
  end
end