class SettingsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @settings = Setting.all
    @setting = Setting.new
  end

  def create
    @setting = Setting.new(setting_params)
    if @setting.save
      redirect_to settings_path, notice: "Chave da API salva com sucesso!"
    else
      @settings = Setting.all
      render :index
    end
  end

  private

  def setting_params
    params.require(:setting).permit(:key)
  end

  def authenticate_admin!
    unless current_user && current_user.admin?
      flash[:alert] = "Acesso negado. Você não tem permissão para acessar esta página."
      redirect_to root_path
    end
  end
end
