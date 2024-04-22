# app/controllers/api/v1/keylockers_controller.rb
module Api
    module V1
      class KeylockersController < ApplicationController
        before_action :set_keylocker, only: [:show, :update, :destroy, :increment_counter]
        skip_before_action :verify_authenticity_token, only: [:new, :create, :update, :increment_counter]
        skip_before_action :authenticate_user!, only: [:new, :create, :update, :increment_counter]
        protect_from_forgery with: :null_session

        # GET /keylockers or /keylockers.json
        def index
          @keylockers = Keylocker.all
          render json: @keylockers
        end


        # GET /keylockers/new
        def new
          @keylocker = Keylocker.new
        end

        # GET /keylockers/1 or /keylockers/1.json
        def show
          render json: @keylocker
        end

      
        # POST /keylockers or /keylockers.json
        def create
          @keylocker = Keylocker.new(keylocker_params)
          
          @keylocker.setdose ||= 200
          @keylocker.valuedrink ||= 2.50
          @keylocker.total ||= 0

        
          respond_to do |format|
            if @keylocker.save
              format.json { render json: { message: "Dispenser foi criado com sucesso.", keylocker: @keylocker }, status: :created, location: @keylocker }
            else
              format.json { render json: @keylocker.errors, status: :unprocessable_entity }
            end
          end
        end

        # PATCH/PUT /api/v1/keylockers/1
        def update
          if @keylocker.update(keylocker_params)
            render json: @keylocker
          else
            render json: @keylocker.errors, status: :unprocessable_entity
          end
        end
        
        # DELETE /api/v1/keylockers/1
        def destroy
          @keylocker.destroy
          head :no_content
        end

        def increment_counter
          if @keylocker
            if @keylocker.increment!(:contDose, 1)
              current_valuedrink = @keylocker.valuedrink.to_f
              current_contDose = @keylocker.contDose
              new_valuedrink = current_valuedrink * current_contDose
              @keylocker.update(total: new_valuedrink)
              render json: @keylocker
            else
              render json: { error: "Erro ao incrementar o contador." }, status: :unprocessable_entity
            end
          else
            render json: { error: "Keylocker não encontrado." }, status: :not_found
          end
        end

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_keylocker
            @keylocker = Keylocker.find(params[:id])
          end

          # Only allow a list of trusted parameters through.
          def keylocker_params
            params.require(:keylocker).permit(:owner, :nameDevice, :ipAddress, :status, :contDose, :fullmax, :setdose, :valuedrink, :total)
          end
      end
    end
  end
  