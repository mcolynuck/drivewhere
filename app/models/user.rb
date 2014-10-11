class User < ActiveRecord::Base
	belongs_to	:role
	belongs_to	:owner

	has_secure_password

	EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

	validates :name,     :presence => true,
						 :uniqueness => true
	validates :first_name, :presence => true
	validates :last_name, :presence => true
	validates :email,    :presence => true,
						 format: {:with => EMAIL_REGEX, message: "format not valid"},
						 :length => {:in => 4..255},
						 :if => :has_email?		# Validates only if they supply an email
	
	# presence of passowrd/confirmation checked via controller via params.require().permit()
	validates :password, :on => :create,
					  	 :length => {:within => 8..100},
					     :confirmation => true

	scope :alphabetical, lambda {order("users.name ASC")}
	scope :newest_first, lambda {order("users.created_by ASC")}
	scope :newest_last, lambda {order("users.created_by DESC")}


	def has_email?	# Was an email address entered in the form?
		email.length > 0
	end

  def active?
  	self.active == true
  end

  def expired?
    self.expiry < Time.now
  end
end
