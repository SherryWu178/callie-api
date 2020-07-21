class JsonWebToken
    class << self
        HMAC_SECRET = ENV['SECRET_KEY_BASE'] || Rails.application.credentials.secret_key_base
        def encode(payload)
            # token expires in 60 minutes
            payload[:exp] = Time.now.to_i + 36000
            JWT.encode(payload, HMAC_SECRET)
        end
        def decode(token)
            begin
                body = JWT.decode(token, HMAC_SECRET)[0]
                {
                    "user_id": 1
                }
                HashWithIndifferentAccess.new(body)
            rescue JWT::DecodeError
                raise(ExceptionHandler::InvalidToken, 
                    Message.invalid_token)
                nil
            end
        end
    end
end