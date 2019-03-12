require 'minitest/autorun'
require 'library'
require 'commands/add'

describe Commands::Add do
  before do
    @lib = Library.new
  end

  describe "#valid?" do
    it 'is false with fewer than 2 argumentss' do
      cmd = Commands::Add.new @lib, ['"a"']
      refute cmd.valid?

      cmd = Commands::Add.new @lib, []
      refute cmd.valid?
    end
    
    it 'is false with more than 2 argumentss' do
      cmd = Commands::Add.new @lib, ['"a"', '"b"', '"c"']
      refute cmd.valid?
    end

    it 'is false with if an argument is quote-wrapped but empty' do
      cmd = Commands::Add.new @lib, ['"a"', '""']
      refute cmd.valid?

      cmd = Commands::Add.new @lib, ['""', '"b"']
      refute cmd.valid?

      cmd = Commands::Add.new @lib, ['""', '""']
      refute cmd.valid?
    end

    it 'is true when both argumentss are quote-wrapped' do
      args = ['"The Dark Side of The Moon"', '"Pink Floyd"']
      cmd = Commands::Add.new @lib, args
      assert cmd.valid?
    end

    it 'is false when either argument is not quote-wrapped' do
      args = ['The Dark Side of The Moon', '"Pink Floyd"']
      cmd = Commands::Add.new @lib, args
      refute cmd.valid?

      args = ['"The Dark Side of The Moon"', 'Pink Floyd']
      cmd = Commands::Add.new @lib, args
      refute cmd.valid?
    end
  end

  describe "#execute" do
    it 'adds an album to the library' do
      args = ['"The Dark Side of The Moon"', '"Pink Floyd"']
      cmd = Commands::Add.new @lib, args
      cmd.execute

      assert @lib.has_key? 'Pink Floyd'
      assert @lib['Pink Floyd'].length == 1
      assert @lib['Pink Floyd'][0][0] == 'The Dark Side of The Moon'
      assert @lib['Pink Floyd'][0][1] == false
    end

    it 'does not add an existing album to the library' do
      args = ['"The Dark Side of The Moon"', '"Pink Floyd"']
      cmd = Commands::Add.new @lib, args
      cmd.execute

      args = ['"The Dark Side of The Moon"', '"Pink Floyd"']
      cmd = Commands::Add.new @lib, args
      cmd.execute

      assert @lib['Pink Floyd'].length == 1
    end

    it 'does not add an existing album to the library even by a different artist' do
      args = ['"The Dark Side of The Moon"', '"Pink Floyd"']
      cmd = Commands::Add.new @lib, args
      cmd.execute

      args = ['"The Dark Side of The Moon"', '"Metallica"']
      cmd = Commands::Add.new @lib, args
      cmd.execute

      refute @lib.has_key? 'Metallica'
    end
  end
end
