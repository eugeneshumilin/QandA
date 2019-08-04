require 'rails_helper'

feature "user can view question and question's answers", "
  In order to find answer
  user can view question and all question's answers
" do
  given(:user) { create :user }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'user tries to view question' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
