require 'rails_helper'

feature 'Author can delete own question', %q{
  In order to delete question
  as authenticated user
  author can delete own question
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario "delete author's own question" do
    sign_in(user)
    visit questions_path
    click_on 'Delete'

    expect(page).to have_content 'Question was successfully deleted'
    expect(page).to have_no_content question.title
  end

  scenario "delete another user's question" do
    sign_in(another_user)
    visit questions_path

    expect(page).to_not have_link 'Delete'
  end

  scenario 'unauthenticated user tries to delete question' do
    visit questions_path

    expect(page).to_not have_link 'Delete'
  end
end