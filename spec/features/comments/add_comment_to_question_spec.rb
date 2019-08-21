require 'rails_helper'

feature 'User can add comments to question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees a new comment link' do
      expect(page).to have_link 'New comment'
    end

    scenario 'tries to add comment to question' do
      click_on 'New comment'
      expect(page).to_not have_link 'New comment'

      fill_in 'Comment', with: 'My comment'
      click_on 'Add comment'

      expect(page).to have_content 'My comment'
      expect(page).to have_link 'New comment'
    end
  end

  context 'mulitple sessions', js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('another_user') do
        another_user = create(:user)

        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        click_on 'New comment'
        fill_in 'Comment', with: 'My comment'
        click_on 'Add comment'

        expect(page).to have_content 'My comment'
      end

      Capybara.using_session('another_user') do
        expect(page).to have_content 'My comment'
      end
    end
  end
end