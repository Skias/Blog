class User < ApplicationRecord
    
    has_secure_password 
    
    def admin?
        self.role == 'admin'
    end

    def editor?
        self.role == 'editor'
    end

    

    has_many :message
    has_many :comment, through: :message
end
