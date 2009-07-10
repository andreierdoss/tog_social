class Member::SharingsController < Member::BaseController

  before_filter :find_group, :except => [:index]
#  before_filter :check_moderator, :except => [:index]

  def index
    @sharing = GroupSharing.new(:shareable_type => params[:shareable_type], :shareable_id => params[:shareable_id])
    @shareable = @sharing.shareable
    @groups = current_user.groups
    @referer = request.referer
    respond_to do |format|
     format.html
    end    
  end

  def create
    if @group.members.include? current_user
      @group.share(current_user, params[:shareable_type], params[:shareable_id])
      respond_to do |format|
         format.js
         format.xml  { render :xml => message, :head => :ok }
      end
    end
  end
  
  def destroy
    @shared = @group.sharings.find :first, 
      :conditions => {:group_id => params[:id], :shareable_type => params[:shareable_type], :shareable_id => params[:shareable_id]}
    if @group.moderators.include? current_user 
      unless @shared == nil
        if @shared.destroy         
          flash[:ok] = I18n.t("tog_social.sharings.remove_share_ok")
          respond_to do |format|
            format.html { redirect_back_or_default(Tog::Config["plugins.tog_user.default_redirect_on_login"]) }
            format.xml
          end
        end
      end
    elsif @group.members.include? current_user
      unless @shared == nil        
        @shared.destroy          
        respond_to do |format|
           format.js
           format.xml  { render :xml => message, :head => :ok }
        end
      end
    end
  end
  
  protected

    def find_group
      @group = Group.find(params[:id]) if params[:id]
    end

    def check_moderator
      unless @group.moderators.include? current_user
        flash[:error] = I18n.t("tog_social.groups.member.not_moderator") 
        redirect_to group_path(@group)
      end
    end

end
