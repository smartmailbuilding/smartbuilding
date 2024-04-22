class KeylockersController < ApplicationController
  before_action :set_keylocker, only: %i[ show edit update destroy ]
  #before_action :authenticate_admin_user! # Certifique-se de ter um método de autenticação de admin
  skip_before_action :verify_authenticity_token, only: [:toggle_and_save_status]
  skip_before_action :authenticate_user!, only: [:toggle_and_save_status]

  # GET /keylockers or /keylockers.json
  def index
    if current_user.admin?
      @keylockers = Keylocker.all.paginate(page: params[:page], per_page: 9)
    else
      @keylockers = current_user.keylockers.paginate(page: params[:page], per_page: 9)
    end
  end

  # GET /keylockers/1 or /keylockers/1.json
  def show
  end

  # GET /keylockers/new
  def new
    @keylocker = Keylocker.new
  end

  # GET /keylockers/1/edit
  def edit
  end

  # POST /keylockers or /keylockers.json
  def create
    @keylocker = Keylocker.new(keylocker_params)
    respond_to do |format|
      if @keylocker.save
        format.html { redirect_to keylocker_url(@keylocker), notice: "Keylocker was successfully created." }
        format.json { render :show, status: :created, location: @keylocker }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @keylocker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /keylockers/1 or /keylockers/1.json
  def update
    respond_to do |format|
      if @keylocker.update(keylocker_params)
        format.html { redirect_to keylocker_url(@keylocker), notice: "Keylocker was successfully updated." }
        format.json { render :show, status: :ok, location: @keylocker }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @keylocker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /keylockers/1 or /keylockers/1.json
  def destroy
    @keylocker.destroy

    respond_to do |format|
      format.html { redirect_to keylockers_url, notice: "Keylocker was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def reset_counter
    if Keylocker.update_all(contDose: 0)
      redirect_to keylockers_path, notice: "Contador resetado com sucesso."
    else
      redirect_to keylockers_path, alert: "Erro ao resetar o contador."
    end
  end

  def assign_keylocker
    user = User.find(params[:user_id])
    keylocker = Keylocker.find(params[:keylocker_id])
    #user.assign_keylocker(keylocker)
    user.keylockers << keylocker
    redirect_to users_path, notice: 'Locker atribuído com sucesso!'
  end

  def remove_keylocker
    #user_locker = UserLocker.find_by(user_id: params[:user_id], keylocker_id: @keylocker.id)
    #user_locker.destroy if user_locker.present?
    user = User.find(params[:user_id])
    keylocker = Keylocker.find(params[:keylocker_id])
    user.remove_keylocker(keylocker)
    redirect_to users_path, notice: 'Locker removido com sucesso!'
  end

  def toggle_and_save_status
    @keylocker = Keylocker.find(params[:id])
    @keylocker.toggle_and_save_status! # Supondo que você tenha um método correspondente no modelo

    respond_to do |format|
      format.json { render json: { status: @keylocker.status } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_keylocker
      @keylocker = Keylocker.find(params[:id])
    end

    def authenticate_admin_user!
      # Adicione lógica para verificar se o usuário é um administrador.
      # Você pode usar Devise's current_user ou outra lógica personalizada.
    end

    # Only allow a list of trusted parameters through.
    def keylocker_params
      params.require(:keylocker).permit(:street, :city, :state, :zip_code, :neighborhood, :nameBuilding, :complement)
    end
end