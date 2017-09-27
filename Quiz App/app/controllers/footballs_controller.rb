class FootballsController < ApplicationController
  before_action :set_football, only: [:show, :edit, :update, :destroy]

  # GET /footballs
  # GET /footballs.json
  def index
    @footballs = Football.all
    @rec1 = Leaderboard.find_by_user_email_and_quiz_id(current_user.email, 2)
    @players1 = Leaderboard.where(quiz_id: 2).order('score DESC')
  end

  # GET /footballs/1
  # GET /footballs/1.json
  def show
    @rec1 = Leaderboard.find_by_user_email_and_quiz_id(current_user.email, 2)
    @current_url1 = request.env['PATH_INFO']
    if (@rec1.state>=1 && @rec1.state < Football.count() && @current_url1 == "/footballs/1")
      @rec1.score = 0
      @rec1.state = 0
      @rec1.save
    end
    if (@football.ques_type.include? "Single")
      if @rec1.state >= Football.count()
        @rec1.state = 0
        @rec1.score = 0
        @rec1.save
      end
      if (@football.answer == params[:option])
        @rec1.state += 1
        @rec1.score = @rec1.score + 100
        @rec1.save
      elsif (params[:option].present? && @football.answer != params[:option])
        @rec1.state += 1
        @rec1.save
      end
    else
      if @rec1.state >= Football.count()
        @rec1.state = 0
        @rec1.score = 0
        @rec1.save
      end
      if (@football.answer == params[:option1].to_s+params[:option2].to_s+params[:option3].to_s+params[:option4].to_s)
        @rec1.score = @rec1.score + 100
        @rec1.state += 1
        @rec1.save
      elsif ((params[:option1].present? || params[:option2].present? || params[:option3].present? || params[:option4].present?) && (@football.answer != params[:option1].to_s+params[:option2].to_s+params[:option3].to_s+params[:option4].to_s))
        @rec1.state += 1
        @rec1.save
      end
    end
  end

  # GET /footballs/new
  def new
    @football = Football.new
  end

  # GET /footballs/1/edit
  def edit
  end

  # POST /footballs
  # POST /footballs.json
  def create
    @football = Football.new(football_params)

    respond_to do |format|
      if @football.save
        format.html { redirect_to @football, notice: 'Football was successfully created.' }
        format.json { render :show, status: :created, location: @football }
      else
        format.html { render :new }
        format.json { render json: @football.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /footballs/1
  # PATCH/PUT /footballs/1.json
  def update
    respond_to do |format|
      if @football.update(football_params)
        format.html { redirect_to @football, notice: 'Football was successfully updated.' }
        format.json { render :show, status: :ok, location: @football }
      else
        format.html { render :edit }
        format.json { render json: @football.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /footballs/1
  # DELETE /footballs/1.json
  def destroy
    @football.destroy
    respond_to do |format|
      format.html { redirect_to footballs_url, notice: 'Football was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_football
      @football = Football.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def football_params
      params.require(:football).permit(:ques_type, :question, :option1, :option2, :option3, :option4, :answer)
    end
end
