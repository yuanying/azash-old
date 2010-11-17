class Entry < ActiveRecord::Base
  belongs_to :site
  has_many :comments, :dependent=>:destroy
  
  def url
    self.site.url + self.path
  end
  
  def exist_page?
    
  end
end
