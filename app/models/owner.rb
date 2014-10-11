class Owner < ActiveRecord::Base
	has_many	:events, dependent: :destroy
	has_many	:districts

	has_many	:owner_event_types, dependent: :destroy
	has_many	:event_types, :through => :owner_event_types
	
	has_many	:owner_districts, dependent: :destroy
	has_many	:districts, :through => :owner_districts
	
	has_many	:owner_severities, dependent: :destroy
	has_many	:severities, :through => :owner_severities

	has_many	:owner_statuses, dependent: :destroy
	has_many    :statuses, :through => :owner_statuses
	
	has_many	:users, dependent: :destroy

	EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

	validates :name, :presence => true,
					 :uniqueness => true
	validates :description, :presence => true,
							:length => {:within => 4..255}
	validates :contact_first, :presence => true
	validates :contact_last, :presence => true
	validates :address_1, :presence => true
	validates :country, :presence => true
	validates :email, :presence => true,
					  :length => {:in => 4..255}
	# The following 3 lines are the long version of the line above and left here for exmaple purposes only.
	#validates_presence_of :name
	#validates_uniqueness_of :name
	#validates_length_of :name, :within => 4..255
	validates_length_of :email, :within => 0..100, :if => :has_email?
	validates_format_of :email, :with => EMAIL_REGEX, :if => :has_email?

	scope :alphabetical, lambda {order("owners.name ASC")}
	scope :newest_first, lambda {order("owners.created_by ASC")}
	scope :newest_last, lambda {order("owners.created_by DESC")}

	def has_email?	# Was an email address supplied?
		email.length > 0
	end
	
	def active?
  		self.active == true
  	end
end
