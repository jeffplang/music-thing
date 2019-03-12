require 'minitest/autorun'
require 'library'
require 'commands/play'

describe Commands::Play do
  describe "#valid?" do
    it 'is true when argument is quote-wrapped' do
      args = ['"The Dark Side of The Moon"']
      cmd = Commands::Play.new @lib, args
      assert cmd.valid?
    end

    it 'is false when argument is not quote-wrapped' do
      args = ['The Dark Side of The Moon']
      cmd = Commands::Play.new @lib, args
      refute cmd.valid?
    end

    it 'is false with fewer than 1 argument' do
      args = []
      cmd = Commands::Play.new @lib, args
      refute cmd.valid?
    end

    it 'is false with more than 1 arguments' do
      args = ['"a"', '"b"']
      cmd = Commands::Play.new @lib, args
      refute cmd.valid?
    end
  end

  describe "#execute" do
    it 'changes an album\'s played status to true' do
      lib = Library.new
      lib['Pink Floyd'] << ['The Dark Side of The Moon', false]

      args = ['"The Dark Side of The Moon"']
      cmd = Commands::Play.new lib, args
      cmd.execute

      title, played = lib['Pink Floyd'][0]
      assert played == true
    end
  end
end
