require 'rails_helper'

feature 'user can view list of questions', %q{
  In order to find question
  user can view list of question
} do

  given!(:questions) { create_list(:question, 3) }

  scenario 'user tries to view list of question' do
    visit questions_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
    expect(page).to have_content questions[2].title
  end
end