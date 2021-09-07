module Orchestrator
  module Logo
    # Return Ansi Logo
    # https://patorjk.com/software/taag/#p=display&f=Soft&t=bonusbits
    # I like that this is shorter height
    def self.ansi
      # Font = Soft
      <<-'HEREDOC'
,--.                                 ,--.   ,--.  ,--.
|  |-.  ,---. ,--,--, ,--.,--. ,---. |  |-. `--',-'  '-. ,---.
| .-. '| .-. ||      \|  ||  |(  .-' | .-. ',--.'-.  .-'(  .-'
| `-' |' '-' '|  ||  |'  ''  '.-'  `)| `-' ||  |  |  |  .-'  `)
 `---'  `---' `--''--' `----' `----'  `---' `--'  `--'  `----'
      HEREDOC
    end

    # Return Ansi Logo
    # https://patorjk.com/software/taag/#p=display&f=Larry%203D&t=bb # Then Customized
    def self.ansi_old
      # Font = Soft
      <<-'HEREDOC'
 __
/\ \
\ \ \____ __
 \ \  __ \\ \  Bonus Bits
  \ \ \_\ \\ \____
   \ \____/ \  __ \
    \/___/ \ \ \_\ \
            \ \____/
             \/___/
      HEREDOC
    end
  end
end
