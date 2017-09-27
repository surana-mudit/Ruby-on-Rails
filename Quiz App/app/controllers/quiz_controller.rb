class QuizController < ApplicationController
  def index
  	@rec = Leaderboard.find_by_user_email_and_quiz_id(current_user.email, 1)
  	@rec1 = Leaderboard.find_by_user_email_and_quiz_id(current_user.email, 2)
  	@rec2 = Leaderboard.find_by_user_email_and_quiz_id(current_user.email, 3)
  	@rec3 = Leaderboard.find_by_user_email_and_quiz_id(current_user.email, 4)
  end
end
