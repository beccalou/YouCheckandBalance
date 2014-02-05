class UsersController < ApplicationController

	def show
		if current_user
			# @user = User.find(params[:id])
			@user = current_user
			@phrases = @user.phrases
			@legislators = Congress.legislators_locate(current_user.address)['results']
			@word = @phrases.first
			@word1 = @phrases[1]
			@word2 = @phrases[2]
			@bills = Congress.bills_search(:query => "#{@word}"){'results'}
			@bills1 = Congress.bills_search(:query => "#{@word1}"){'results'}
			@bills2 = Congress.bills_search(:query => "#{@word2}"){'results'}
			@new_phrase = Phrase.new
			# @phrases = Phrase.where(user_id: params[:id])
		else
			# render text: "Please Sign In"
			redirect_to users_path
		end
	end

	def edit
		@user = User.find(current_user)
	end

	def update
		@user = User.find(current_user.id)
		@user.assign_attributes(user_params)
    	if @user.save
      	flash[:notice] = 'Address Updated!'
      	redirect_to user_path(current_user.id)
    	else
      	flash.now[:errors] = @user.errors.full_messages
      	render :edit
    	end
	end

end

private

def user_params
	params.require(:user).permit(:first_name, :last_name, :address, :email)
end