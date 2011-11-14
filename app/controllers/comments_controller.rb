class CommentsController < ApplicationController
  unless Rails.env == 'production'
    before_filter :set_access_control_allow_origin
  end
  before_filter :load_site
  before_filter :load_entry, :except => :recent
  
  # GET /comments
  # GET /comments.xml
  def index
    @comments = @entry.comments.order('created_at DESC').page(params[:page]).per(40)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end
  
  def recent
    @comments = Comment.find( :all,
                              :limit      => 10,
                              :include    => [:entry => :site],
                              :conditions => ['entries.site_id = ?', @site.id],
                              :order      => 'comments.created_at desc'
    )
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])
    @comment.entry      = @entry
    @comment.ip_address = request.remote_ip
    @comment.referrer   = params[:referrer] if params[:referrer]
    @comment.user_agent = request.env['HTTP_USER_AGENT']

    respond_to do |format|
      if @comment.save
        format.html { redirect_to(@entry.url) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def load_site
    @site = Site.find(params[:site_id])
  end
  
  def load_entry
    path    = params[:path]
    @entry  = Entry.find_by_path(path)
    unless @entry
      @entry      = Entry.new
      @entry.site = @site
      @entry.path = path
    end
    if @entry.valid? && @entry.exist_page?
      @entry.save! #if @entry.new_record?
    else
      raise ActiveRecord::RecordNotFound
    end
  end
  
  def set_access_control_allow_origin
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Credentials'] = 'true'
  end
  
end
