require 'nokogiri'
require 'open-uri'

class SongScraper

  def self.scrape!
    spotify = GeekierFactory.factorize(File.join(Rails.root, '/lib/spotify.json'))
    albums = []
    tracks = []

    (1963..1979).each do |year|
      doc = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/#{year}_in_music"))
    
      month = 0
      first = false
      doc.css('div#mw-content-text > *').each do |tr|
        tr.css('.mw-headline').each do |b|
          month += 1
        end
        tr.css('td:not(.plainlist) > i').each do |text|
          unless first
            month = 1
            first = true
          end
          albums << {month: month, year: year, album: text.content, artist: text.parent.next.next.content} rescue puts "\n#{month}-#{year}\n " + text.inspect
        end
        break if month > 12
      end
    end unless $testing
    (1980..2003).each do |year|
      doc = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/#{year}_in_music"))
    
      month = 0
      doc.css('tr').each do |tr|
        tr.css('td > b:first-child').each do |b|
          month += 1
        end
        tr.css('td:not(.plainlist) > i').each do |text|
          albums << {month: month, year: year, album: text.content, artist: text.parent.next.next.content} rescue puts "\n#{month}-#{year}\n " + text.inspect
        end
        break if month > 12
      end
      break if $testing
    end

    albums.each do |album|
      begin
        resp = JSON.parse spotify.available_actions['Search albums'].first.call(:q => album[:album] + ' ' + album[:artist])[:response].body
        matches = resp['albums']
        match = nil
        matches.each do |m|
          match = JSON.parse(spotify.available_actions['Lookup'][1].call(:uri => m['href'], :extras => 'trackdetail')[:response].body)
          break if match['album']['artist'] == album[:artist] && match['album']['released'] == album[:year]
        end
        next unless match && match.has_key?('album')
        match['album']['tracks'].compact.each do |t|
          tracks << t.merge({year: album[:year], album: album[:album], month: album[:month], artist: album[:artist]})
          Track.find_or_create_by_title_and_artist(t['name'], album[:artist], album_name: album[:album], year: album[:year], month: album[:month], spotify_href: t['href'], popularity: t['popularity'])
        end
        break if $testing
      rescue Exception => e
        puts "Exception looking up #{album[:album]} (#{album[:year]})"
        puts e.message
        puts e.backtrace.join("\n")
        sleep 2
        next
      end
    end
    tracks
  end
end