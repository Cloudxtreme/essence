require 'spec_helper'

feature 'Playing timelets' do

  context 'with one timelet' do

    background do
      visit '/timelet'
      create_timelet 'My first timelet', 15
      fake_time

      within 'section.timelets' do
        first('.load').click
      end
      find('.button.play').click
    end

    scenario 'creating and playing a timelet' do
      advance 7

      get_timer().should be_within(2).of(8)
    end

    scenario 'letting a timelet end' do
      advance 16

      get_timer().should equal 0
    end

    scenario 'restarting a timelet' do
      advance 8

      within 'section.clock' do
        find('.button.reset').click
      end

      get_timer().should be_within(2).of(15)
    end

  end

  context 'with a looping timelets' do

    background do
      visit '/timelet'
      create_timelet 'My first timelet', 9, true
      fake_time

      within 'section.timelets' do
        first('.load').click
      end
      find('.button.play').click
    end

    scenario 'creating and playing the timelet' do
      advance 30

      get_timer().should be_within(2).of(6)
    end

    scenario 'restarting the timelet' do
      advance 12

      within 'section.clock' do
        find('.button.reset').click
      end

      get_timer().should be_within(2).of(9)
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
        page.should have_field 'name', with: 'My first timelet'
        page.should have_field 'name', with: 'My second timelet'
      end

      within 'section.timelets' do
        load_timelet 'My second timelet'
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
