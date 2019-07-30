require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  as an question's author
  i'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:url) { 'https://thoughtbot.com' }
  given(:gist_url) { 'https://gist.github.com/eugeneshumilin/9396d814f0cfd5510ae9ce091a1e9069' }

  before do
    sign_in(user)
    visit new_question_url
  end

  scenario 'user adds link when asks question' do
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    fill_in 'Link name', with: 'My url'
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'My url', href: url
  end

  scenario 'user adds link when asks question' do
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_content 'Hello Thinknetica!'
  end

end