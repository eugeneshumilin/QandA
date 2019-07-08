require 'rails_helper'

feature 'user can create answer', %q{
  In order to help people
  user can create answer
} do
  given!(:question) { create(:question) }

  background do
    visit question_path(question)
  end
  scenario 'user tries to create answer with valid attributes' do
    fill_in 'Body', with: 'Test answer'
    click_on 'Reply'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'Test answer'
  end

  scenario 'user tries to create answer with in-valid attributes' do
    click_on 'Reply'

    expect(page).to have_content "Body can't be blank"
  end
end