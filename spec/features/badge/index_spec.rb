require 'rails_helper'

feature 'User can view list of his awards', "
  In order to view the list of awards
  As an author of best answer
  I'd like to be able to see my badges
 " do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:badges) { create_list(:badge, 3, question: question) }

  before do
    sign_in(user)

    badges.each do |badge|
      user.get_reward!(badge)
      add_image_to(badge)
    end
  end

  scenario 'user sees a link to awards' do
    expect(page).to have_link 'My badges'
  end

  scenario 'user sees a badges list' do
    visit badges_path

    user.badges.each do |badge|
      expect(page).to have_content badge.question.title
      expect(page).to have_css("img[src*='#{badge.image.filename}']")
      expect(page).to have_content badge.title
    end
  end
end
