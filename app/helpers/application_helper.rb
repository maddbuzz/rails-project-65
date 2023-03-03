# frozen_string_literal: true

module ApplicationHelper
  def get_alert_class(flash_type)
    class_from_type = {
      notice: 'alert-success',
      alert: 'alert-danger'
    }
    "alert #{class_from_type[flash_type.to_sym]}"
  end
end
