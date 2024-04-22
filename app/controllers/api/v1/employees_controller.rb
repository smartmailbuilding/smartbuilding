I18n.locale = :pt

module Api
  module V1
    class EmployeesController < ApplicationController
      skip_before_action :verify_authenticity_token, only: [:libera_dose, :register_card, :create_user, :check_access]
      skip_before_action :authenticate_user!, only: [:libera_dose, :register_card, :create_user, :check_access]

      def libera_dose
        card_rfid = params[:cardRFID]
        employee = Employee.find_by(cardRFID: card_rfid)
      
        if employee
          log_message = "Acesso liberado para Name: #{employee.name}, Lastname: #{employee.lastname}, CompanyID: #{employee.companyID}, Phone: #{employee.phone}, Function: #{employee.function}"
          save_log(log_message, employee)
          render json: {
            name: employee.name,
            lastname: employee.lastname,
            companyID: employee.companyID,
            phone: employee.phone,
            function: employee.function
          }, status: :ok
        else
          render json: { message: "Acesso negado" }, status: :unprocessable_entity
        end
      end
      
      def check_access
        card_rfid = params[:cardRFID]
        employee = Employee.find_by(cardRFID: card_rfid)

        if employee
          render json: { message: "Acesso liberado", employee: employee }, status: :ok
        else
          render json: { message: "Acesso negado" }, status: :unprocessable_entity
        end
      end
      
      def register_card
        rfid_user = params[:cardRFID]
    
        # Verifica se o cartão já está cadastrado
        existing_employee = Employee.find_by(cardRFID: rfid_user)
    
        if existing_employee
          render json: { message: 'Este cartão já está cadastrado.', employee_id: existing_employee.id }
        else
          # Cria um novo funcionário com base no número do cartão
          new_employee = Employee.create(cardRFID: rfid_user)
    
          if new_employee.valid?
            render json: { message: 'Funcionário cadastrado com sucesso.', employee_id: new_employee.id }
          else
            render json: { message: 'Falha ao cadastrar funcionário.', errors: new_employee.errors.full_messages }
          end
        end
      end

      def create_user
        if params[:cardRFID]
          card_rfid = params[:cardRFID]
          history_entry = HistoryEntry.find_by(saveCards: card_rfid)
          save_card(card_rfid)
          HistoryEntryDestroyJob.set(wait: 5.minutes).perform_later
          render json: { message: "Cartão RFID #{card_rfid} salvo com sucesso." }, status: :ok
        else
          render json: { error: "Parâmetro cardRFID ausente." }, status: :unprocessable_entity
        end
      end
      
      private

      def save_log(message, employee)
        Log.create(message: message, employee_info: {
          name: employee.name,
          lastname: employee.lastname,
          companyID: employee.companyID,
          phone: employee.phone,
          function: employee.function
        })
      end

      def save_card(card_rfid)
        HistoryEntry.create(saveCards: card_rfid)
      end

      def allow_cors
        # Configuração para permitir solicitações de origens diferentes (CORS)
        response.headers['Access-Control-Allow-Origin'] = '*'
        response.headers['Access-Control-Allow-Methods'] = 'POST, PUT, PATCH, GET, OPTIONS'
        response.headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
      end

    end
  end
end