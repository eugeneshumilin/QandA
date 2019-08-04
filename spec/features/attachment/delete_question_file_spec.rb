require 'rails_helper'

feature 'Author can remove files from his own question', '
  In order to remove unnecessary files
  from his own question
  Author can delete files
' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  background do
    attach_file_to(question)
    visit question_path(question)
  end

  scenario "delete author's files from his own question", js: true do
    sign_in(user)

    within ".attachment-#{question.files.first.id}" do
      click_on 'Remove file'
    end

    within ".question-#{question.id}" do
      expect(page).to_not have_link 'rails_helper.rb'
    end
  end

  scenario "delete another user's question", js: true do
    sign_in(another_user)

    expect(page).to_not have_link 'Remove file'
  end

  scenario 'unauthenticated user tries to delete question', js: true do
    expect(page).to_not have_link 'Remove file'
  end
end
