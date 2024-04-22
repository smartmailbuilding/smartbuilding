class HistoricoController < ApplicationController
  def index
    @logs = Log.all.paginate(page: params[:page], per_page: 9)
  end
end
