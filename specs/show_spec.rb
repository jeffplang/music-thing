require 'minitest/autorun'
require 'library'
require 'commands/show'

describe Commands::Show do
  describe "#valid?" do
    it 'is true when first argument is "all" or "unplayed"' do
      args = ['all']
      cmd = Commands::Show.new @lib, args
      assert cmd.valid?

      args = ['unplayed']
      cmd = Commands::Show.new @lib, args
      assert cmd.valid?
    end

    it 'is false when first argument is not "all" or "unplayed"' do
      args = ['some']
      cmd = Commands::Show.new @lib, args
      refute cmd.valid?
    end

    describe "with by clause" do
      it 'is true if second argument is "by" and artist is quote wrapped' do
        args = ['all', 'by', '"Pink Floyd"']
        cmd = Commands::Show.new @lib, args
        assert cmd.valid?
      end

      it 'is false if second argument is present and is not "by"' do
        args = ['all', 'from', '"Pink Floyd"']
        cmd = Commands::Show.new @lib, args
        refute cmd.valid?
      end

      it 'is false if artist is not quote-wrapped' do
        args = ['all', 'from', 'Metallica']
        cmd = Commands::Show.new @lib, args
        refute cmd.valid?
      end
    end
  end

  describe "#execute" do
    before do
      @lib = Library.new
      @lib['Pink Floyd'] << ['The Dark Side of The Moon', false]
      @lib['Pink Floyd'] << ['Meddle', true]
      @lib['Metallica'] << ['Master of Puppets', false]
      @lib['Metallica'] << ['Load', true]

      @output = StringIO.new
      $stdout = @output
    end
    after do
      $stdout = STDOUT
    end

    describe "all" do
      it 'shows entire library' do
        cmd = Commands::Show.new @lib, ['all']
        cmd.execute

        assert @output.string.split("\n").length == 4
        assert @output.string.include? 'The Dark Side of The Moon'
        assert @output.string.include? 'Meddle'
        assert @output.string.include? 'Master of Puppets'
        assert @output.string.include? 'Load'
      end

      it 'shows a single artist\'s library with by clause' do
        cmd = Commands::Show.new @lib, ['all', 'by', '"Metallica"']
        cmd.execute

        assert @output.string.split("\n").length == 2
        refute @output.string.include? 'The Dark Side of The Moon'
        refute @output.string.include? 'Meddle'
        assert @output.string.include? 'Master of Puppets'
        assert @output.string.include? 'Load'
      end

      it 'shows unplayed by all artists' do
        cmd = Commands::Show.new @lib, ['unplayed']
        cmd.execute

        assert @output.string.split("\n").length == 2
        assert @output.string.include? 'The Dark Side of The Moon'
        refute @output.string.include? 'Meddle'
        assert @output.string.include? 'Master of Puppets'
        refute @output.string.include? 'Load'
      end

      it 'shows unplayed by a single artist with by clause' do
        cmd = Commands::Show.new @lib, ['unplayed', 'by', '"Metallica"']
        cmd.execute

        assert @output.string.split("\n").length == 1
        refute @output.string.include? 'The Dark Side of The Moon'
        refute @output.string.include? 'Meddle'
        assert @output.string.include? 'Master of Puppets'
        refute @output.string.include? 'Load'
      end
    end
  end
end
