require 'spec_helper'

feature 'Visiting timelet index' do

  background do
    visit '/timelet'
  end

  scenario 'Viewing the clock' do
    page.should have_content 'Your Clock'
  end
end
