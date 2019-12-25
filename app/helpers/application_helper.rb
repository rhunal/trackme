module ApplicationHelper
  def _import_link_tag(controller_name, action_name)
    return nil unless action_name == 'index'
    return nil unless respond_to?("import_#{controller_name}_path")

    @target_link = send("import_#{controller_name}_path")

    link_to "Import", @target_link, class: 'dropdown-item'
  end

  def _back_link_tag(controller_name, action_name)
    @target_link = root_path if action_name == 'index'
    @target_link = send("#{controller_name}_path") unless action_name == 'index'

    link_to "Back", @target_link, class: 'btn btn-default'
  end

  def _new_link_tag(controller_name, action_name)
    return if action_name == 'new'

    # For incomming manifests
    return if action_name == 'incomming'
    # @target_link = root_path if action_name == 'index'
    @target_link = send("new_#{controller_name.singularize}_path")

    @anchor_text = "New #{(controller_name.split('_') - ['masters']).map(&:singularize).join(' ').titlecase}"
    @anchor_text = 'New AWB status' if controller_name == 'docket_status_masters'
    link_to @anchor_text, @target_link, class: 'btn btn-primary'    
  end

  def _edit_link_tag(controller_name, action_name, object_id)
    return unless action_name == 'show'
    @object = controller_name.classify.constantize.find(object_id)
    @target_link = edit_polymorphic_path(@object)

    @anchor_text = "Edit"
    link_to @anchor_text, @target_link, class: 'btn btn-default'        
  end

  def _delete_link_tag(controller_name, action_name, object_id)
    return unless %w|show edit|.include? action_name
    @object = controller_name.classify.constantize.find(object_id)
    @target_link = polymorphic_path(@object)

    @anchor_text = "Delete"
    link_to @anchor_text, @target_link, class: 'btn btn-danger', method: :delete, data: {confirm: "Are you sure? you want to delete #{controller_name.singularize}: #{@object.try(:to_s)}"}        
  end
end
