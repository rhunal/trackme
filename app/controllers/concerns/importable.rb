module Importable
  extend ActiveSupport::Concern

  def import
    add_breadcrumb "Import #{controller_name.titleize}", instance_variable_get("@#{controller_name.singularize}")

    respond_to do |format|
      format.html { render 'shared/import' }  
    end
  end

  def import_post
    file_path = params[:file].try(:path)
    klass = controller_name.classify.constantize
    
    data = klass.import_csv(file_path)
    redirect_to send("#{controller_name}_path"), notice: "Success !!"
  # rescue StandardError => ex
  #   flash[:alert] = "error: #{ex.message}"
  #   redirect_to send("import_#{controller_name}_path")
  end

  def download_sample
    send_file Rails.root.join('lib', 'sample', "#{controller_name}.csv")
  end
end