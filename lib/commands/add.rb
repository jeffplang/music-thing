require_relative '../library'
require_relative 'base'

module Commands
  class Add < Base
    SYNTAX = 'To Add: add "album" "artist"'

    def valid?
      @args.length == 2 && @args.all?(QUOTE_WRAPPED)
    end

    def execute
      album, artist = @args.map{ |t| t.tr '"', '' }

      if Library.find_album(album)
        puts "Already have \"#{album}\""
      else
        Library[artist] << [album, false]
        puts "Added \"#{album}\" by #{artist}"
      end
    end
  end
end
