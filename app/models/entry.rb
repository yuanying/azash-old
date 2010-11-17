require 'uri'
require 'net/http'

class Entry < ActiveRecord::Base
  belongs_to :site
  has_many :comments, :dependent=>:destroy
  
  validates_format_of :path, :with => /^(\/[\-.!~*'();\/?:@&=+$,%#\w]*)$/
  
  def url
    self.site.url + self.path
  end
  
  def exist_page?
    uri = URI.parse(self.url)
    Net::HTTP.version_1_2
    Net::HTTP.start(uri.host, uri.port) do |http|
      temp = uri.path
      temp += ( '?' + uri.query ) if uri.query
      response = http.head(temp)
      return response.code.to_i < 400
    end
  end
  
  def akismet
    unless @akismet
      akismet_api_key       = nil
      akismet_api_key_file  = File.join(Rails.root, 'akismet_api_key.txt')

      if File.file?(akismet_api_key_file)
        open(akismet_api_key_file) do |io|
          akismet_api_key = io.read.strip
        end
      end

      if akismet_api_key
        @akismet = Akismet.new(akismet_api_key, self.site.url)
      end
    end
    @akismet
  end
end



