require 'rails_helper'

feature 'user can view list of questions', %q{
  In order to find question
  user can view list of question
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'user tries to view list of question' do
    sign_in(user)
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end