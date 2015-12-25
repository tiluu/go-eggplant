module RelationshipHelper
    def getName(email)
        User.find_by(email: email).name
    end
end
