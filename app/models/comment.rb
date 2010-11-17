class Comment < ActiveRecord::Base
  belongs_to :entry
  
  def validate
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
        errors.add(:content, t('activerecord.errors.messages.is_spam'))
      end
    end
  end
end
