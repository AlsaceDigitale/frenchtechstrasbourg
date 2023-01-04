xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "French Tech Strasbourg"
    xml.description I18n.t("startups.index")
    xml.link headlines_url

    for headline in @headlines
      xml.item do
        xml.title headline.title
        xml.description headline.body
        xml.pubDate headline.published_at.to_s(:rfc822)
        xml.link headline_url(headline)
        xml.guid headline_url(headline)
      end
    end
  end
end