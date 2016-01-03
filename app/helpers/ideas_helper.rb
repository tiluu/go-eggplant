module IdeasHelper
    def idea_user(idea)
        user = User.find_by(id: idea.user_id)
        user.present? ? user : ''
    end

    def display_idea(*info)
        if info.length === 1
            info[0].present? ? info[0] : "n/a"
        else
            result = []
            info.each do |i|
                i.present? ? result << i : result << "n/a"
            end
            result.join(" to ")
        end
    end

end
