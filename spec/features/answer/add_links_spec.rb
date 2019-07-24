require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  as an answer's author
  i'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:url) { 'https://thoughtbot.com' }
  given(:gist_url) { 'https://gist.github.com/eugeneshumilin/9396d814f0cfd5510ae9ce091a1e9069' }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'user adds link when asks question', js: true do
    fill_in 'Body', with: 'Answer body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: url

    click_on 'Reply'

    within '.answers' do
      expect(page).to have_link 'My gist', href: url
    end
  end

  scenario 'user adds gist link when asks question', js: true do
    fill_in 'Body', with: 'Answer body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Reply'

    within '.answers' do
      expect(page).to have_content 'Hello Thinknetica!'
    end
  end
end