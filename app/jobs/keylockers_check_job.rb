# app/jobs/keylockers_check_job.rb
class KeylockersCheckJob < ApplicationJob
    queue_as :default
  
    def perform
      # Verifica se existem registros na tabela keylockers
      keylockers = Keylocker.all
      phone = current_user.phone
      message = "Procure seu fornecedor de bebidas para repor seu estoque"
  
      keylockers.each do |keylocker|
        # Verifica se o campo setdose é igual a 50 e contDose é maior ou igual a 300
        if keylocker.setdose == 50 && keylocker.contDose >= 300
          send_notification(phone, message)
        end
  
        # Verifica se o campo setdose é igual a 200 e contDose é maior ou igual a 75
        if keylocker.setdose == 200 && keylocker.contDose >= 75
           send_notification(phone, message)
        end
  
        # Verifica se o campo setdose é igual a 400 e contDose é maior ou igual a 37
        if keylocker.setdose == 400 && keylocker.contDose >= 37
           send_notification(phone, message)
        end
  
        # Verifica se o campo setdose é igual a 600 e contDose é maior ou igual a 25
        if keylocker.setdose == 600 && keylocker.contDose >= 25
           send_notification(phone, message)
        end
      end
    end

    def send_sms_(phone, pin)
        api_key = '05LleS23oQMPDXClXuLl' # Substitua pela sua chave de API
        puts "Telefone: #{phone}"
        puts "Seu novo PIN é: #{pin}"
        message = "Seu novo PIN é: #{pin}"
        url = "https://sistema81.smsbarato.com.br/send?chave=#{CGI.escape(api_key)}&dest=#{CGI.escape(phone)}&text=#{CGI.escape(message)}"  
    end
  
    private
  
    def send_notification(phone, message)
        api_key = '05LleS23oQMPDXClXuLl' # Substitua pela sua chave de API
        puts "Telefone: #{phone}"
        puts "Mensagem: #{message}"
        url = "https://sistema81.smsbarato.com.br/send?chave=#{CGI.escape(api_key)}&dest=#{CGI.escape(phone)}&text=#{CGI.escape(message)}"  
    end
  end
  