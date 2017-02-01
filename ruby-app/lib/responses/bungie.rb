module Response
  class Bungie < Base
    def initialize(user)
      super()
      @user = user
      @text = "<@#{@user}> :notes: _\"We are programmed to receive. You can check-out any time you like, But you can never leave!\"_ :notes:"
    end

    def self.triggered_by?(message)
      # channel join
    end
  end
end
