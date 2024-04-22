class Keylocker < ApplicationRecord
    #validates_uniqueness_of :owner, scope: [:nameDevice, :status]
    has_many :user_lockers
    has_many :users, through: :user_lockers
    has_many :employees_keylockers
    has_and_belongs_to_many :employees

    after_update :atualizar_valordose, if: :contDose_changed?

    def toggle_and_save_status!
        # Implemente a lógica para alternar e salvar o status no banco de dados
        self.status = (status == 'bloqueado' ? 'desbloqueado' : 'bloqueado')
        save!
    end

    private
end
