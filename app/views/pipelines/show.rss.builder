xml.instruct! :xml, version: "1.0"

xml.rss version: "2.0" do
  xml.channel do
    xml.title @pipeline.name.presence || @pipeline.id
    xml.link pipeline_url(@pipeline)

    @items.each do |item|
      xml.item do
        xml.title item.rss_title
        xml.description item.rss_description, type: :html
        xml.pubDate item.rss_pub_date
        xml.link item.rss_link
        xml.guid item.rss_guid
      end
    end
  end
end
