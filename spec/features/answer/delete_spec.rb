require 'rails_helper'

feature 'Author can delete own answer', '
  In order to delete answer
  as authenticated user
  author can delete own answer
' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario "delete author's own answer", js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_on 'Delete answer'
    end

    page.driver.browser.switch_to.alert.accept
    expect(page).to have_no_content answer.body
  end

  scenario "delete another user's answer", js: true do
    sign_in(another_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'unauthenticated user tries to delete answer', js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Delete answer'
    end
  end
end
