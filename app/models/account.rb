class Account < ActiveRecord::Base
	has_many :tasks
	has_ancestry
	
end
