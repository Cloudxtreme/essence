require 'spec_helper'

feature 'Playing timelets' do

  context 'with one timelet' do

    background do
      visit '/timelet'
      create_timelet 'My first timelet', 15
      fake_time
    end

    scenario 'creating and playing a timelet' do
      within 'section.timelets' do
        first('.load').click
      end
      find('.button.play').click

      advance 7

      get_timer().should be_within(2).of(8)
    end

    scenario 'letting a timelet end' do
      within 'section.timelets' do
        first('.load').click
      end
      find('.button.play').click

      advance 16

      get_timer().should equal 0
    end

  end

  context 'with two timelets' do

    background do
      visit '/timelet'
      create_timelet 'My first timelet', 15
      create_timelet 'My second timelet', 30
      fake_time
    end

    scenario 'loading a timelet while another one is running' do

      within 'section.timelets' do
        page.should have_content 'My first timelet'
        page.should have_content 'My second timelet'
      end

      within 'section.timelets' do
        find('h3', text: 'My second timelet').find('.load').click
      end

      within 'section.clock' do
        page.should have_content '30'
      end

      find('.button.play').click

      advance 20

      get_timer().should be_within(2).of(10)

      within 'section.timelets' do
        first('.load').click
      end

      get_timer().should equal 15

      advance 10

      get_timer().should equal 15
    end

  end


  private

  def get_timer
    find('.timer .time').text.to_i
  end

end
