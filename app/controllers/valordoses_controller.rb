class ValordosesController < ApplicationController
  before_action :set_valordose, only: %i[ show edit update destroy ]

  # GET /valordoses or /valordoses.json
  def index
    @valordoses = Valordose.all
    @last_valordose = Valordose.last
  end

  # GET /valordoses/1 or /valordoses/1.json
  def show
  end

  # GET /valordoses/new
  def new
    @valordose = Valordose.new
  end

  # GET /valordoses/1/edit
  def edit
  end

  # POST /valordoses or /valordoses.json
  def create
    @valordose = Valordose.new(valordose_params)
    @valordose.user = current_user  # Assumindo que você tenha um método current_user que retorna o usuário atualmente autenticado


    respond_to do |format|
      if @valordose.save
        format.html { redirect_to valordoses_path, notice: "O valor da dose foi criado com sucesso" }
        format.json { render :show, status: :created, location: @valordose }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @valordose.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /valordoses/1 or /valordoses/1.json
  def update
    respond_to do |format|
      if @valordose.update(valordose_params)
        format.html { redirect_to valordose_url(@valordose), notice: "Valordose was successfully updated." }
        format.json { render :show, status: :ok, location: @valordose }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @valordose.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /valordoses/1 or /valordoses/1.json
  def destroy
    @valordose.destroy

    respond_to do |format|
      format.html { redirect_to valordoses_url, notice: "Valordose was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_valordose
      @valordose = Valordose.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def valordose_params
      params.require(:valordose).permit(:value, :price)
    end
end
