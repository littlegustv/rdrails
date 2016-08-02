module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    
    def connect
      self.current_user = find_verified_user
      ActionCable.server.broadcast "server", message: "login", user: self.current_user.id
    end

    protected
    

    def find_verified_user
      if current_user = User.find(cookies.signed['user.id'])
        current_user
      else
        User.last
      end
    end

  end
end
