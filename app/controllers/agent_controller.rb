class AgentController < ApplicationController
  layout false

  def index
    @base_url = 'http://through711.herokuapp.com/'
    render 'agent/index'
  end

  def link
    @base_url = 'http://through711.herokuapp.com/'
    encoded_link = params[:link]
    @gotten_link = Base64.decode64(encoded_link)
    response = HTTParty.get @gotten_link
    content_type = response.headers["content-type"]
    if content_type.to_s.include?('html')
      @content = change_link(response.body)
    else
      @content = response.body
    end
    render 'agent/link', :content_type => content_type, :status => response.code
  end

  def change_link(body)
    html = Nokogiri::HTML(body)
    change_url_in_html html, '//a', 'href'
    change_url_in_html html, '//link', 'href'
    change_url_in_html html, '//script', 'src'
    change_url_in_html html, '//img', 'src'
    html.to_html
  end

  def change_url_in_html(html, tag, att)
    html.xpath(tag).each do |element|
      next if element[att].nil?
      if element[att].to_s.start_with?('/', '.')
        url = URI.parse(@gotten_link)
        element[att] = (url + element[att].to_s).to_s
      end
      element[att] = @base_url + Base64.strict_encode64(element[att].to_s)
    end
  end
end
