require 'nokogiri'

class Swirl
  def initialize
    @db = nil
    @html = ""
  end

  def add_html(html)
    @html += html
  end

  def use_affiliate_database(db)
    @db = db
  end

  def money_making_html
    frag = Nokogiri::HTML.fragment(@html)
    frag.traverse do |n|
      if n.text?
        n.replace(n.content.split(" ").map do |word|
          clean_word = word.strip.downcase.gsub(/\W+/, '')
          if _db_has_word?(clean_word) && !_db_word_link(clean_word).empty?
            "<a href=\"#{_db_word_link(clean_word)}\">#{word}</a>"
          else
            word
          end
        end.join(" "))
      end
    end
    frag.to_html
  end

  def _db_has_word?(word)
    @db && @db.respond_to?(:has_word?) ? @db.has_word?(word) : false
  end

  def _db_word_link(word)
    if @db && @db.respond_to?(:get_links_for_word)
      @db.get_links_for_word(word).sort_by { |i| i[:amount] }.reverse.first[:url]
    else
      ""
    end
  end
end
