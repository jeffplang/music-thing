module Commands
  class Base
    QUOTE_WRAPPED = /^"[[:print:]]+"$/

    def initialize(args = [])
      @args = args
    end
  end
end
