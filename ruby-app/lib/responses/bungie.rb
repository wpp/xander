module Response
  class Bungie
    def initialize(user)
      @user = user
    end

    def text
      "<@#{@user}> :notes: _\"We are programmed to receive. You can check-out any time you like, But you can never leave!\"_ :notes:"
    end
  end
end
