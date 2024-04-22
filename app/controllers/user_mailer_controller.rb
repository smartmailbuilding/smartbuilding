class UserMailerController < ApplicationController
    def send_email
      user = current_user # Ou qualquer lógica para encontrar o usuário
      UserMailer.send_email(user).deliver_now
      redirect_to root_path, notice: 'E-mail enviado com sucesso!'
      puts "passou aqui"
    end
end