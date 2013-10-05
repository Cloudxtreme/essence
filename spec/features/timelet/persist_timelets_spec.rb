require 'spec_helper'

feature 'Creating timelets' do

  background do
    visit '/timelet'
  end

  scenario 'storing timelets in localStorage' do
    create_timelet 'My first timelet', 15
    create_timelet 'My second timelet', 30

    within 'section.timelets' do
      page.should have_content 'My first timelet'
      page.should have_content 'My second timelet'
    end

    visit '/timelet'

    within 'section.timelets' do
      page.should have_content 'My first timelet'
      page.should have_content 'My second timelet'
    end
  end

  scenario 'loading timelets from localStorage' do
    create_timelet 'My first timelet', 15
    create_timelet 'My second timelet', 30

    within 'section.timelets' do
      page.should have_content 'My first timelet'
      page.should have_content 'My second timelet'
    end

    within 'section.timelets' do
      find_timelet('My first timelet').click
    end
    first_timelet_path = current_path

    within 'section.timelets' do
      page.should have_content 'My first timelet'
      page.should have_content 'My second timelet'
    end

    within 'section.timelets' do
      find_timelet('My second timelet').click
    end
    second_timelet_path = current_path

    visit first_timelet_path

    within 'section.clock' do
      page.should have_content '15'
    end

    within 'section.timelets' do
      page.should have_content 'My first timelet'
      page.should have_content 'My second timelet'
    end

    visit second_timelet_path

    within 'section.clock' do
      page.should have_content '30'
    end

    within 'section.timelets' do
      page.should have_content 'My first timelet'
      page.should have_content 'My second timelet'
    end
  end

  private

  # Finds the timelet with the given name
  #
  # @param [String] name the name of the timelet
  #
  def find_timelet(name)
    find :xpath, "//section[@class='timelets']//span[contains(text(),'#{name}')]/../span[contains(@class,'load')]"
  end

end
