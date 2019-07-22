require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  as an question's author
  i'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/eugeneshumilin/626279f75be581697c8d09e064e36c05' }

  scenario 'user adds link when asks question' do
    sign_in(user)
    visit new_question_url

    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

end