# This file authenticates a valid user by generating a JWT token
class AuthenticateUser
    def initialize(email, password)
        @email, @password = email, password
    end
    def token
        JsonWebToken.encode({ user_id: user.id })
    end

    attr_reader :email, :password

    private
    def user
        user = User.find_by(email: email)
        if user && user.authenticate(password)
            return user
        else
            raise(ExceptionHandler::AuthenticationError, 
                Message.invalid_credentials)
        end
    end
end