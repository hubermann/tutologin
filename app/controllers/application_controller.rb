class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :checklogueado

  #evito que se pueda ir a login  estando logueado
  before_filter :save_login_state, :only => [:login, :login_attempt]


  protected 
  #chequea si hay login para mostrar en applications.html.erb las opciones de login o no
	  def checklogueado
	  			unless session[:user_id]
						@current_user = nil
						return false
					else
						# set current user object to @current_user object variable
						@current_user = User.find(session[:user_id])
						return true
					end
	  end
	 #verifica si esta autenticado para realizar acciones en los controladores que se necesiten
		def authenticate_user
					unless session[:user_id]
						flash[:notice] = "necesita estar logueado!"
						#guardo desde donde viene para enviarlo ahi despues de loguearse
						store_location
						redirect_to(:controller => 'sessions', :action => 'login')
						return false
					else
						# set current user object to @current_user object variable
						@current_user = User.find(session[:user_id])
						return true
					end
		end



		def store_location
			#guarda la url desde donde quizo acceder y se le solicito login
      session[:return_to] = request.url
    end

		#verifica que si el login exista no se pueda ingresar al form de login
		def save_login_state
					if session[:user_id]
							flash[:notice] = "Ya estas logueado, :("
							redirect_to(root_path)
							return false
					else
						return true
					end
		end

end
