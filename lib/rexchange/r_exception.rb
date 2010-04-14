
module RExchange
  class RException < Exception

    attr_reader :req, :res

    def initialize(req, res, oryg)
      super(oryg.to_s)
      set_backtrace oryg.backtrace
      @oryg = oryg
      @req = req
      @res = res
    end

    def message
      inspect
    end

    def inspect
      "#{super.inspect} req:#{@req.inspect} body:[#{@req.body}] headers:[#{@req.to_hash}] href:[#{@req.path}] res:#{@res.inspect} oryginal message:#{@oryg.message} ."
    end
  end


end
