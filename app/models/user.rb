class User < ActiveRecord::Base
 
	 attr_accessible :nombre, :apellido, :email, :password, :password_confirmation, :email_confirmation
  attr_accessor :password
				EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}$/i
				validates :nombre, :apellido, :length => { :in => 6..20 } , :format => { :with => /\A[a-zA-Z0-9]+\z/, :message => "Only letters and numbers allowed" }
				validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX 
				validates :password, :confirmation => true 
				validates :email, :confirmation => true 
				validates_length_of :password, :in => 6..20, :on => :create

				has_many :posts

  #require de el tipo de encriptacion para el pass
  require 'digest/sha1'

  #antes de guardar el password lo encripto
  before_save :encrypt_password
  #despues de guardar el password en la columna encrypted_password el password q llego por form lo paso a nil
	after_save :clear_password

	#encripto_password y lo guardo en encrypted_password (nombre de mi columna en la BD)
	def encrypt_password
		 if password.present?
			self.salt = BCrypt::Engine.generate_salt
			self.encrypted_password= BCrypt::Engine.hash_secret(password, salt)
		end
	end

	#limpio el valor que llego en el campo password desde el formulario
	def clear_password
		self.password = nil
	end

	def self.authenticate(user_email="", user_password="")
	if  EMAIL_REGEX.match(user_email)    
		user = User.find_by_email(user_email)
	end

	if user && user.match_password(user_password)
		return user
	else
		return false
	end
end   

def match_password(user_password="")
	encrypted_password == BCrypt::Engine.hash_secret(user_password, salt)
end

end
