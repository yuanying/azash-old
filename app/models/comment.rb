require 'yaml'

class Comment < ActiveRecord::Base
  belongs_to :entry
  
  validates_length_of :name, :within => 1..32
  validates_length_of :content, :within => 1..1024
  validates_length_of :email, :within => 0..250
  validates_length_of :url, :within => 0..250
  
  validate :check_akismet
  validate :check_blacklist

  def formatted_content
    unless @formatted_content
      @formatted_content = self.html_escape(self.content)
      @formatted_content = @formatted_content.gsub(/\n/, '<br />')
    end
    @formatted_content
  end
  
  def check_blacklist
    blacklist = YAML.load_file(Rails.root.to_s + "/config/blacklist.yml")
    blacklist.each do |word|
      if self.name.include?(word) || self.email.include?(word) || self.url.include?(word) || self.content.include?(word)
        errors.add(:content, 'is spam.')
      end
    end
  end

  def check_akismet
    akismet = self.entry.akismet
    if akismet && akismet.verified?
      if akismet.comment_check(
        :user_ip => self.ip_address, 
        :user_agent => self.user_agent,
        :referrer => self.referrer,
        :permalink => self.entry.url,
        :comment_type=>'comment',
        :comment_author => self.name,
        :comment_author_email => self.email,
        :comment_author_url => self.url,
        :comment_content => self.content
      )
        # errors.add(:content, t('activerecord.errors.messages.is_spam'))
        errors.add(:content, 'is spam.')
      end
    end
  end
  
  protected
  HTML_ESCAPE = { '&' => '&amp;', '>' => '&gt;', '<' => '&lt;', '"' => '"' }
  def html_escape(s)
    s = s.to_s
    s.gsub(/[&"><]/) { |special| HTML_ESCAPE[special] }
  end
end
