module Commands
  class Base
    QUOTE_WRAPPED = /^"[[:print:]]+"$/

    def initialize(library, args = [])
      @library = library
      @args = args
    end
  end
end
