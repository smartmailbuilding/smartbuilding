class Employee < ApplicationRecord
    belongs_to :user
    has_and_belongs_to_many :keylockers
    has_one_attached :profile_picture
    has_many :employee_actions

    validate :at_least_one_keylocker

  
    private

    def at_least_one_keylocker
      errors.add(:base, 'Deve haver pelo menos um dispenser atribuído') if keylockers.none?
    end
  
    
  end
  