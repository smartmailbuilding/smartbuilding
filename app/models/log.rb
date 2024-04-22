class Log < ApplicationRecord
  validates :message, presence: true

  def formatted_employee_info
    formatted_info = ""
    if employee_info.is_a?(Hash)
      employee_info.each do |key, value|
        formatted_info << "#{key.capitalize}: #{value}\n"
      end
    else
      formatted_info = employee_info
    end
    formatted_info << "\nCreated At: #{created_at}"
    formatted_info
  end
end
