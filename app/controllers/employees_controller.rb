require 'cgi'
require 'rest-client'

class EmployeesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:toggle_and_save_status, :reset_pin, :send_sms_with_new_pin, :destroy]
  skip_before_action :authenticate_user!, only: [:toggle_and_save_status, :reset_pin, :send_sms_with_new_pin, :destroy]
  before_action :set_employee, only: %i[ show edit update destroy ]
  before_action :authenticate_user!


  # GET /employees or /employees.json
  def index
    if current_user.admin?
      #@employees = Employee.all
      @employees = Employee.includes(:user).all.paginate(page: params[:page], per_page: 9)
      @users = User.all.includes(:keylockers, employee: :keylocker).paginate(page: params[:page], per_page: 9)
    else
      @employees = Employee.where(user_id: current_user.id).paginate(page: params[:page], per_page: 9)
    end
  end

  # GET /employees/1 or /employees/1.json
  def show
    @employee = Employee.find(params[:id])
    @employee_actions = @employee.employee_actions
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees or /employees.json
  def create
    @employee = Employee.new(employee_params)
    @employee.user = current_user  
    @employee.keylockers = current_user.keylockers
    respond_to do |format|
      if @employee.save
        format.html { redirect_to employee_url(@employee), notice: "Funcionário foi criado com sucesso." }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /employees/1 or /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to employee_url(@employee), notice: "Funcionário foi atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1 or /employees/1.json
  def destroy
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to employees_url, notice: "Funcionário foi deletado com sucesso." }
      format.json { head :no_content }
    end
  end

  def enviar_mensagem_whatsapp
    url = 'https://v5.chatpro.com.br/chatpro-6m8favcrd9/api/v1/send_message'
    headers = {
      'Authorization': '51b3f07ad623b39e4dc6ce9af96551a8',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }
    @employee = Employee.find(params[:id])
  
    phone = @employee.phone
    nome = @employee.name
    sobrenome = @employee.lastname
    numeroapart = @employee.numberHouse
  
    puts "Enviando Whatsapp para #{nome} #{sobrenome} (Apartamento #{numeroapart})..."
    mensagem = "Olá #{nome} #{sobrenome}, morador do #{numeroapart} sua encomenda chegou e encontra na portaria"

    payload = {
      number: phone,
      message: mensagem
    }

    #redirect_to employee_path(@employee), notice: 'Whatsapp enviado com sucesso!'

    @employee.employee_actions.create(
    action_type: "Enviar Whatsapp",
    action_description: "Whatsapp enviado para o morador em #{Time.zone.now.strftime("%d/%m/%Y - %H:%M")}"
    )

    begin
      response = RestClient.post(url, payload.to_json, headers)
      render json: { success: true, response: response.body }
    rescue RestClient::ExceptionWithResponse => e
      render json: { success: false, error: e.response.body }, status: e.response.code
    rescue RestClient::Exception => e
      render json: { success: false, error: e.message }, status: :internal_server_error
    end
  end

  def send_sms
    @employee = Employee.find(params[:id])
  
    phone = @employee.phone
    nome = @employee.name
    sobrenome = @employee.lastname
    numeroapart = @employee.numberHouse
  
    puts "Enviando SMS para #{nome} #{sobrenome} (Apartamento #{numeroapart})..."
  
    message = "Ola #{nome}, morador do apto. #{numeroapart}. Sua encomenda chegou na portaria do seu predio!"
    send_sms_to_employee(phone, message)
    redirect_to employee_path(@employee), notice: 'SMS enviado com sucesso!'

    @employee.employee_actions.create(
    action_type: "Enviar SMS",
    action_description: "SMS enviado para o morador em #{Time.zone.now.strftime("%d/%m/%Y - %H:%M")}"
    )
  end

  def import
    begin
      file = params[:file]
      spreadsheet = Roo::Spreadsheet.open(file.path)
      header = spreadsheet.row(1)
      
      ActiveRecord::Base.transaction do
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          employee = Employee.new
          employee.attributes = row.to_hash.slice("name", "lastname", "numberHouse", "phone", "email")
          employee.user = current_user
          employee.keylockers = current_user.keylockers
          employee.save!
        end
      end
      
      redirect_to employees_path, notice: "Planilha importada com sucesso!"
    rescue StandardError => e
      redirect_to employees_path, alert: "Erro ao importar a planilha: #{e.message}"
    end
  end
  

  def send_email
    @employee = Employee.find(params[:id])

    # Configurando as configurações de e-mail
    ActionMailer::Base.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 465,
      user_name:            'smartmailbuilding@gmail.com',
      password:             'ebzzwrvykwihempj',
      authentication:       'plain',
      enable_starttls_auto: true,
      tls:                  true
    }

    # Enviar o e-mail
    UserMailer.send_email(@employee).deliver_now

    redirect_to employee_path(@employee), notice: 'E-mail enviado com sucesso!'
    @employee.employee_actions.create(
      action_type: "Enviar Email",
      action_description: "Email enviado para o morador em #{Time.zone.now.strftime("%d/%m/%Y - %H:%M")}"
      )  
  end
 
  def toggle_and_save_status
    @employee = Employee.find(params[:id])
    @employee.update(status: (@employee.status == 'bloqueado' ? 'desbloqueado' : 'bloqueado'))
    respond_to do |format|
      format.json { render json: { status: @employee.status } }
    end
  end

  
  private

    def send_sms_to_employee(phone, message)
      # Busca a última chave da API salva no banco de dados
      api_key = Setting.last&.key
      puts "API KEY: #{api_key}"
      puts "PHONE: #{phone}"
      puts "MESSAGE: #{message}"

      #api_key = '05LleS23oQMPDXClXuLl' # Substitua pela sua chave de API

      
      # Verifica se há uma chave da API disponível
      if api_key.present?
        # Adicionando os parâmetros diretamente na URL com a chave da API encontrada
        url = "https://sistema81.smsbarato.com.br/send?chave=#{CGI.escape(api_key)}&dest=#{CGI.escape(phone)}&text=#{CGI.escape(message)}"
        
        puts "Fazendo solicitação POST para: #{url}"
        begin
          # Fazendo a solicitação GET
          response = RestClient.post(url, {})
          puts "Resposta do servidor: #{response.body}"
          puts "Código de status: #{response.code}"
        rescue RestClient::ExceptionWithResponse => e
          puts "Erro na solicitação: #{e.response.body}"
          puts "Código de status: #{e.response.code}"
        end
      else
        puts "Nenhuma chave da API encontrada"
        # Retorna um erro apropriado ou lida com a situação de outra maneira
    raise "Nenhuma chave da API encontrada"
      end
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def employee_params
      params.require(:employee).permit(:name, :lastname, :numberHouse, :phone, :email, :profile_picture)
    end
end