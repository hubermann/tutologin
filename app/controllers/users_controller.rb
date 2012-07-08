class UsersController < ApplicationController

	before_filter :save_login_state, :only => [:new, :create]

	def index
		@users = User.all
	end

	def new
		@user = User.new
	end

	def create 
		@user = User.new(params[:user])
		if @user.save
			flash[:notice] = "Cuenta creada!"
			redirect_to root_path
		else
			render 'new'
		end
	end

	 def profile
	 	unless session[:user_id]
	 		#si no hay session de user lo envio a login y guardo la url (profile) para enviarlo al ingresar
	 		store_location
  		redirect_to login_path
  	else
  	@user = User.find(session[:user_id])
  	end
  end


	 def update
    @user = User.find(session[:user_id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to profile_path, notice: 'account was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "profile" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.destroy
        format.html { redirect_to users_path, notice: 'account was successfully updated.' }
        format.json { head :ok }
      else
        format.html { redirect_to 'users' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end




end
