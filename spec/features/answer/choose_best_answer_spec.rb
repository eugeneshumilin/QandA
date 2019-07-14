require 'rails_helper'

feature 'User can choose the best answer', %q{
  In order to choose best answer
  as an author of question
  I'd like to be able mark the best answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer_list) { create_list(:answer, 5, question: question, user: user) }
  given!(:best_answer) { create(:answer, question: question, user: user) }

  scenario 'Author of question tries to choose best answer', js: true do
    sign_in(user)
    visit question_path(question)

    within ".answer-#{best_answer.id}" do
      click_link "best answer"
      expect(page).to_not have_link "best answer"
    end

    expect(page.find('.answers div:first-child')).to have_content best_answer.body
    expect(page).to have_css('.best-answer')
  end

  scenario 'another user tries to choose best answer' do
    sign_in(another_user)
    visit question_path(question)

    within ".answer-#{answer_list[0].id}" do
      expect(page).to_not have_link "best answer"
    end
  end
end