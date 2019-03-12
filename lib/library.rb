require 'forwardable'

class Library
  extend Forwardable
  def_delegators :@data, :[], :each, :slice, :has_key?

  def initialize
    @data = Hash.new{ |hash, key| hash[key] = [] }
  end

  def find_album(title)
    @data.each do |artist, albums|
      albums.each do |album|
        return [artist, album] if album[0] == title
      end
    end
    nil
  end
end
