class CricketsController < ApplicationController
  before_action :set_cricket, only: [:show, :edit, :update, :destroy]

  # GET /crickets
  # GET /crickets.json
  # def current_user
    # @current_user ||= User.find_by(id: session[:user_id])
  # end
  
  def index
    @crickets = Cricket.all
    @rec = Leaderboard.find_by_user_email_and_quiz_id(current_user.email, 1)
    @players = Leaderboard.where(quiz_id: 1).order('score DESC')
    # print("hello")
    # print(current_user)
  end

  # GET /crickets/1
  # GET /crickets/1.json
  def show
    @rec = Leaderboard.find_by_user_email_and_quiz_id(current_user.email, 1)
    @current_url = request.env['PATH_INFO']
    if (@rec.state>=1 && @rec.state < Cricket.count() && @current_url == "/crickets/1")
      @rec.score = 0
      @rec.state = 0
      @rec.save
    end
    if (@cricket.ques_type.include? "Single")
      if @rec.state >= Cricket.count()
        @rec.state = 0
        @rec.score = 0
        @rec.save
      end
      if (@cricket.answer == params[:option])
        @rec.state += 1
        @rec.score = @rec.score + 100
        @rec.save
      elsif (params[:option].present? && @cricket.answer != params[:option])
        @rec.state += 1
        @rec.save
      end
    else
      if @rec.state >= Cricket.count()
        @rec.state = 0
        @rec.score = 0
        @rec.save
      end
      if (@cricket.answer == params[:option1].to_s+params[:option2].to_s+params[:option3].to_s+params[:option4].to_s)
        @rec.score = @rec.score + 100
        @rec.state += 1
        @rec.save
      elsif ((params[:option1].present? || params[:option2].present? || params[:option3].present? || params[:option4].present?) && (@cricket.answer != params[:option1].to_s+params[:option2].to_s+params[:option3].to_s+params[:option4].to_s))
        @rec.state += 1
        @rec.save
      end
    end  
  end

  # GET /crickets/new
  def new
    @cricket = Cricket.new
  end

  # GET /crickets/1/edit
  def edit
  end

  # POST /crickets
  # POST /crickets.json
  def create
    @cricket = Cricket.new(cricket_params)

    respond_to do |format|
      if @cricket.save
        format.html { redirect_to @cricket, notice: 'Cricket was successfully created.' }
        format.json { render :show, status: :created, location: @cricket }
      else
        format.html { render :new }
        format.json { render json: @cricket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /crickets/1
  # PATCH/PUT /crickets/1.json
  def update
    respond_to do |format|
      if @cricket.update(cricket_params)
        format.html { redirect_to @cricket, notice: 'Cricket was successfully updated.' }
        format.json { render :show, status: :ok, location: @cricket }
      else
        format.html { render :edit }
        format.json { render json: @cricket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crickets/1
  # DELETE /crickets/1.json
  def destroy
    @cricket.destroy
    respond_to do |format|
      format.html { redirect_to crickets_url, notice: 'Cricket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cricket
      @cricket = Cricket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cricket_params
      params.require(:cricket).permit(:ques_type, :question, :option1, :option2, :option3, :option4, :answer)
    end
 
  # if Leaderboard.where(:user_email => current_user.email, :quiz_id => 1).exists?
  #   print("hi") 
  # else
  #   # print(current_user.id)
  #   Leaderboard.create :user_email => current_user.email, :quiz_id => 1, :score => 0, :state => 0
  # end 
end