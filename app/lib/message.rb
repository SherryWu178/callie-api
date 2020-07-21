class Message
    def self.not_found(record = 'record')
        'Sorry, #{record} not found.'
    end
    def self.invalid_credentials
        'Invalid credentials.'
    end

    def self.invalid_token
        'Invalid or expired token.'
    end

    def self.missing_token
        'Missing token.'
    end

    def self.expired_token
        'Sorry, your token has expired. Please login to continue.'
    end

    def self.unauthorized
        'Unauthorized request.'
    end

    def self.account_not_created
        'Account could not be created.'
    end

    def self.account_deleted
        'Your account is successfully removed.'
    end

    def self.account_not_deleted
        'The account failed to be deleted.'
    end

end