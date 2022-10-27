class SourcesUsersController < ApplicationController
  before_action :set_sources_user, only: %i[ show edit update destroy ]

  # GET /sources_users or /sources_users.json
  def index
    @sources_users = SourcesUser.all
  end

  # GET /sources_users/1 or /sources_users/1.json
  def show
  end

  # GET /sources_users/new
  def new
    @sources_user = SourcesUser.new
  end

  # GET /sources_users/1/edit
  def edit
  end

  # POST /sources_users or /sources_users.json
  def create
    @sources_user = SourcesUser.new(sources_user_params)

    respond_to do |format|
      if @sources_user.save
        format.html { redirect_to sources_user_url(@sources_user), notice: "Sources user was successfully created." }
        format.json { render :show, status: :created, location: @sources_user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sources_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sources_users/1 or /sources_users/1.json
  def update
    respond_to do |format|
      if @sources_user.update(sources_user_params)
        format.html { redirect_to sources_user_url(@sources_user), notice: "Sources user was successfully updated." }
        format.json { render :show, status: :ok, location: @sources_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sources_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sources_users/1 or /sources_users/1.json
  def destroy
    @sources_user.destroy

    respond_to do |format|
      format.html { redirect_to sources_users_url, notice: "Sources user was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sources_user
      @sources_user = SourcesUser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sources_user_params
      params.require(:sources_user).permit(:source_id, :user_id)
    end
end
