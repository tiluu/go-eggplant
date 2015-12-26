module ValidEmails
    extend ActiveSupport::Concern
    include ActiveModel::Validations

    included do
        validates :email, format: { with: /\A[\w+\-._]+?@[a-z\d\-.]+\.[a-z]+\z/i,
                                message: "Invalid format for email address" }

        before_validation :downcase_email
    end

    def downcase_email
        self.email = email.downcase
    end
end
