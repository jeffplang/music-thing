require_relative '../library'
require_relative 'base'

module Commands
  class Show < Base
    SYNTAX = 'To Show: show <all | unplayed> [ by "artist" ]'

    def parse_args
      @scope = @args[0]
      @by = @args[2].tr('"', '') if valid_by_clause?
    end

    def valid?
      valid_scope? && (@args.length > 1 ? valid_by_clause? : true)
    end

    def valid_scope?
      @args.length >= 1 && @args[0] == 'all' || @args[0] == 'unplayed'
    end

    def valid_by_clause?
      @args.length == 3 && @args[1] == 'by' && @args[2] =~ QUOTE_WRAPPED
    end

    def execute
      parse_args

      collection = @by ? Library.slice(@by) : Library

      collection.each do |artist, albums|
        albums.each do |album, played|
          next if @scope == 'unplayed' && played

          print "\"#{album}\" by #{artist}"
          suffix = @scope == 'all' ? " (#{'un' unless played}played)" : ""
          puts suffix
        end
      end
    end
  end
end
