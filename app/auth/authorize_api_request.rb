# This class is initialized with a http headers object, 
# attempts to extract the authentication token
# and decodes the token to verify if it is valid
class AuthorizeApiRequest
    def initialize(headers = {})
        @headers = headers
    end
    def user
        decoded_token = JsonWebToken.decode(token)
        begin
            User.find(decoded_token[:user_id])          
        rescue => err
            raise(ActiveRecord::RecordNotFound, 
                err.message)
            nil
        end
    end

    private
    attr_reader :headers
    def token
        # { Authorization: 'Bearer <token>' }
        if headers['Authorization'].present?
            headers['Authorization'].split(' ').last
        else
            raise(ExceptionHandler::MissingToken, 
                Message.missing_token)
        end
    end
end