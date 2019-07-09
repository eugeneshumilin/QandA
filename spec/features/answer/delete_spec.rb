require 'rails_helper'

feature 'Author can delete own answer', %q{
  In order to delete answer
  as authenticated user
  author can delete own answer
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario "delete author's own answer" do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content 'Answer was successfully deleted'
    expect(page).to have_no_content answer.body
  end

  scenario "delete another user's answer" do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'unauthenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end