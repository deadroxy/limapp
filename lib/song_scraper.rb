require 'nokogiri'
require 'open-uri'

class SongScraper

  def self.scrape!
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
          "#{month}-#{year}: " +  text.content + ' ---- ' + text.parent.next.next.content rescue puts "\n#{month}-#{year}\n " + text.inspect
        end
        break if month > 12
      end
    end
    (1980..2003).each do |year|
      doc = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/#{year}_in_music"))
    
      month = 0
      doc.css('tr').each do |tr|
        tr.css('td > b:first-child').each do |b|
          month += 1
        end
        tr.css('td:not(.plainlist) > i').each do |text|
          "#{month}-#{year}: " +  text.content + ' ---- ' + text.parent.next.next.content rescue puts text.inspect
        end
        break if month > 12
      end
    end
  end
end