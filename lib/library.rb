require 'forwardable'

class Library
  @data = Hash.new{ |hash, key| hash[key] = [] }

  extend SingleForwardable
  def_delegators :@data, :[], :each, :slice

  class << self
    def find_album(title)
      @data.each do |artist, albums|
        albums.each do |album|
          return [artist, album] if album[0] == title
        end
      end
      nil
    end
  end
end
