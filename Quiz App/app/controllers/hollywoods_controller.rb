class HollywoodsController < ApplicationController
  before_action :set_hollywood, only: [:show, :edit, :update, :destroy]

  # GET /hollywoods
  # GET /hollywoods.json
  def index
    @hollywoods = Hollywood.all
    @rec3 = Leaderboard.find_by_user_email_and_quiz_id(current_user.email, 4)
    @players3 = Leaderboard.where(quiz_id: 4).order('score DESC')
  end

  # GET /hollywoods/1
  # GET /hollywoods/1.json
  def show
    @rec3 = Leaderboard.find_by_user_email_and_quiz_id(current_user.email, 4)
    @current_url3 = request.env['PATH_INFO']
    if (@rec3.state>=1 && @rec3.state < Hollywood.count() && @current_url3 == "/hollywoods/1")
      @rec3.score = 0
      @rec3.state = 0
      @rec3.save
    end
    if (@hollywood.ques_type.include? "Single")
      if @rec3.state >= Hollywood.count()
        @rec3.state = 0
        @rec3.score = 0
        @rec3.save
      end
      if (@hollywood.answer == params[:option])
        @rec3.state += 1
        @rec3.score = @rec3.score + 100
        @rec3.save
      elsif (params[:option].present? && @hollywood.answer != params[:option])
        @rec3.state += 1
        @rec3.save
      end
    else
      if @rec3.state >= Hollywood.count()
        @rec3.state = 0
        @rec3.score = 0
        @rec3.save
      end
      if (@hollywood.answer == params[:option1].to_s+params[:option2].to_s+params[:option3].to_s+params[:option4].to_s)
        @rec3.score = @rec3.score + 100
        @rec3.state += 1
        @rec3.save
      elsif ((params[:option1].present? || params[:option2].present? || params[:option3].present? || params[:option4].present?) && (@hollywood.answer != params[:option1].to_s+params[:option2].to_s+params[:option3].to_s+params[:option4].to_s))
        @rec3.state += 1
        @rec3.save
      end
    end
  end

  # GET /hollywoods/new
  def new
    @hollywood = Hollywood.new
  end

  # GET /hollywoods/1/edit
  def edit
  end

  # POST /hollywoods
  # POST /hollywoods.json
  def create
    @hollywood = Hollywood.new(hollywood_params)

    respond_to do |format|
      if @hollywood.save
        format.html { redirect_to @hollywood, notice: 'Hollywood was successfully created.' }
        format.json { render :show, status: :created, location: @hollywood }
      else
        format.html { render :new }
        format.json { render json: @hollywood.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hollywoods/1
  # PATCH/PUT /hollywoods/1.json
  def update
    respond_to do |format|
      if @hollywood.update(hollywood_params)
        format.html { redirect_to @hollywood, notice: 'Hollywood was successfully updated.' }
        format.json { render :show, status: :ok, location: @hollywood }
      else
        format.html { render :edit }
        format.json { render json: @hollywood.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hollywoods/1
  # DELETE /hollywoods/1.json
  def destroy
    @hollywood.destroy
    respond_to do |format|
      format.html { redirect_to hollywoods_url, notice: 'Hollywood was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hollywood
      @hollywood = Hollywood.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hollywood_params
      params.require(:hollywood).permit(:ques_type, :question, :option1, :option2, :option3, :option4, :answer)
    end
end
