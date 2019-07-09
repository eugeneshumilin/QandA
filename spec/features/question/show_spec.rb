require 'rails_helper'

feature "user can view question and question's answers", %q{
  In order to find answer
  user can view question and all question's answers
} do
  given(:user) { create (:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  scenario 'user tries to view question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end
end