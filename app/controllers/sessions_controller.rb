class SessionsController < ApplicationController

	#debe estar logueado para poder acceder a perfil
	before_filter :authenticate_user, :only => [:profile]

  def login
  	#@login = []
  end

 

  def check_login
  	#voy al modelo de user a authenticate
		authorized_user = User.authenticate(params[:user_email],params[:user_password])
		if authorized_user
				session[:user_id] = authorized_user.id
				flash[:notice] = "Welcome again, you logged in as #{authorized_user.nombre } #{authorized_user.email}"
							
				#si habia una url desde donde quizo ingresar y se le solicito login lo envio
				#la url viene desde un campo hidden en el form donde lo pase para no perderlo al 
				#hacer checklogin en el modelo User.rb
				if params[:return_to]
						redirect_to params[:return_to]
						else
						#sino habia una url desde donde quizo ingresar lo envio al root_path
						redirect_to root_path
						end
		else
				session[:return_to] = params[:return_to]
				flash[:notice] = "Invalid Username or Password"
				flash[:color]= "invalid"
				render "login"	
		end			

	end

	def logout
		session[:user_id] = nil
		flash[:notice] = "Logged out!"
		redirect_to root_path
	end

end
