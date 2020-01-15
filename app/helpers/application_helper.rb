module ApplicationHelper
  def is_active?(link_path)
   current_page?(link_path) ? "active" : ""
  end

  def flash_class(level)
    case level
      when "success" then "alert alert-success"
      when "notice" then "alert alert-info"
      when "error" then "alert alert-warning"
      when "danger" then "alert alert-danger"
    end
  end
end
