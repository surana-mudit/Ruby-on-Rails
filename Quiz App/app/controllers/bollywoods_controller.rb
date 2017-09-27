class BollywoodsController < ApplicationController
  before_action :set_bollywood, only: [:show, :edit, :update, :destroy]

  # GET /bollywoods
  # GET /bollywoods.json
  def index
    @bollywoods = Bollywood.all
    @rec2 = Leaderboard.find_by_user_email_and_quiz_id(current_user.email, 3)
    @players2 = Leaderboard.where(quiz_id: 3).order('score DESC')
  end

  # GET /bollywoods/1
  # GET /bollywoods/1.json
  def show
    @rec2 = Leaderboard.find_by_user_email_and_quiz_id(current_user.email, 3)
    @current_url2 = request.env['PATH_INFO']
    if (@rec2.state>=1 && @rec2.state < Bollywood.count() && @current_url2 == "/bollywoods/1")
      @rec2.score = 0
      @rec2.state = 0
      @rec2.save
    end
    if (@bollywood.ques_type.include? "Single")
      if @rec2.state >= Bollywood.count()
        @rec2.state = 0
        @rec2.score = 0
        @rec2.save
      end
      if (@bollywood.answer == params[:option])
        @rec2.state += 1
        @rec2.score = @rec2.score + 100
        @rec2.save
      elsif (params[:option].present? && @bollywood.answer != params[:option])
        @rec2.state += 1
        @rec2.save
      end
    else
      if @rec2.state >= Bollywood.count()
        @rec2.state = 0
        @rec2.score = 0
        @rec2.save
      end
      if (@bollywood.answer == params[:option1].to_s+params[:option2].to_s+params[:option3].to_s+params[:option4].to_s)
        @rec2.score = @rec2.score + 100
        @rec2.state += 1
        @rec2.save
      elsif ((params[:option1].present? || params[:option2].present? || params[:option3].present? || params[:option4].present?) && (@bollywood.answer != params[:option1].to_s+params[:option2].to_s+params[:option3].to_s+params[:option4].to_s))
        @rec2.state += 1
        @rec2.save
      end
    end
  end

  # GET /bollywoods/new
  def new
    @bollywood = Bollywood.new
  end

  # GET /bollywoods/1/edit
  def edit
  end

  # POST /bollywoods
  # POST /bollywoods.json
  def create
    @bollywood = Bollywood.new(bollywood_params)

    respond_to do |format|
      if @bollywood.save
        format.html { redirect_to @bollywood, notice: 'Bollywood was successfully created.' }
        format.json { render :show, status: :created, location: @bollywood }
      else
        format.html { render :new }
        format.json { render json: @bollywood.errors, status: :unprocessabl2e_entity }
      end
    end
  end

  # PATCH/PUT /bollywoods/1
  # PATCH/PUT /bollywoods/1.json
  def update
    respond_to do |format|
      if @bollywood.update(bollywood_params)
        format.html { redirect_to @bollywood, notice: 'Bollywood was successfully updated.' }
        format.json { render :show, status: :ok, location: @bollywood }
      else
        format.html { render :edit }
        format.json { render json: @bollywood.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bollywoods/1
  # DELETE /bollywoods/1.json
  def destroy
    @bollywood.destroy
    respond_to do |format|
      format.html { redirect_to bollywoods_url, notice: 'Bollywood was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bollywood
      @bollywood = Bollywood.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bollywood_params
      params.require(:bollywood).permit(:ques_type, :question, :option1, :option2, :option3, :option4, :answer)
    end
end
