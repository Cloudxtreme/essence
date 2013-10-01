require 'spec_helper'

feature 'Playing timelets' do

  background do
    visit '/timelet'
    fake_time
    create_clock_timelet 'My first timelet', 15
  end

  scenario 'creating and playing a timelet' do
    find('.button.play').click

    advance 7

    get_timer().should be_within(2).of(8)
  end

  scenario 'letting a timelet end' do
    find('.button.play').click

    advance 16

    get_timer().should equal 0
  end

  scenario 'loading an playing a timelet' do
    within 'section.timelets' do
      first('.load').click
    end

    find('.button.play').click

    advance 9

    get_timer().should be_within(2).of(6)
  end

  scenario 'loading a timelet while another one is running' do
    find('.add').click
    create_clock_timelet 'My second timelet', 30

    within 'section.timelets' do
      page.should have_content 'My first timelet (15s)'
      page.should have_content 'My second timelet (30s)'
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


  private

  def get_timer
    find('.timer .time').text.to_i
  end

end
