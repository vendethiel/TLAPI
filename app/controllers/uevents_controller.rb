class UeventsController < ApplicationController

  @@document = Nokogiri::HTML(open('http://www.teamliquid.net/'))

  def show
    lives = @@document.css('div.ev-upc')
    ids = lives.css('span[data-event-id]').collect{|a| a.attribute('data-event-id')}

    render json: JSON.generate({ids: ids}), status: 200
  end

  def get_info
    ups = @@document.css('div.ev-upc')
    uevent = ups.select{|upc|
      upc.css('span[data-event-id]').first.attribute('data-event-id').to_s == params['id']
    }
    title = uevent.first.css('span[data-event-id]').first.content
    timer = uevent.first.css('span.ev-timer').first.content
    date = uevent.first.css('span.ev-timer').first.attribute('title')
    game = %w(??? sc2 scbw csgo hots ssb)[/\d(?=\.png)/.match(uevent.first.css('span.ev').first.attribute('style'))[0].to_i]

    render json: JSON.generate({uevent: {name: title, date:  date, timer: timer, game: game}}), status: 200
  end

end
