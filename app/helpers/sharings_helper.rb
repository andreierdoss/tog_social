module SharingsHelper
  
  def share_with_groups_link(shareable, only_moderated_groups=false)
    return if !shareable
    groups = only_moderated_groups ? current_user.moderated_groups : current_user.groups
    render :partial => 'shared/share_with_groups', :locals => {:groups => groups, :shareable => shareable}
  end
    
  def share_link(share_with, shareable_type, shareable_id)
    link_to_remote I18n.t("tog_social.sharings.share"),
        :url => member_share_with_group_path(share_with, shareable_type, shareable_id),
        :html => {:title => I18n.t("tog_social.sharings.share_with", :name => share_with.name)}
  end
  
  def remove_share_link(share_with, shareable_type, shareable_id)
    link_to_remote I18n.t("tog_social.sharings.remove_share"),
        :url => member_remove_share_from_group_path(share_with, shareable_type, shareable_id),
        :html => {:title => I18n.t("tog_social.sharings.remove_share_from", :name => share_with.name)}
  end
  
  def shareable_title(shareable)
    if (shareable.respond_to?(:name))
      string = shareable.name
    else
      string = shareable.title
    end
    string
  end
  
  def sharings_link(share_with, shareable)
    content_tag :div, :id => "sharings_group_#{share_with.id}" do
      if share_with.shared?(shareable)
        remove_share_link(share_with, shareable.class.to_s, shareable.id)
      else
        share_link(share_with, shareable.class.to_s, shareable.id)
      end
    end
  end
end

