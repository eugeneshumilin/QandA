require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  as an answer's author
  i'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/eugeneshumilin/626279f75be581697c8d09e064e36c05' }

  scenario 'user adds link when asks question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'Answer body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Reply'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end