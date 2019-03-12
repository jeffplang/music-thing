require_relative 'base'

module Commands
  class Play < Base
    SYNTAX = 'To Play: play "album"'

    def valid?
      @args.length == 1 && @args.all?(QUOTE_WRAPPED)
    end

    def execute
      album_name = @args[0].tr '"', ''
      artist, album = @library.find_album(album_name)

      if artist.nil?
        puts 'Album not found'
      else
        album[1] = true
        puts "Playing \"#{album[0]}\" by #{artist}"
      end
    end
  end
end
