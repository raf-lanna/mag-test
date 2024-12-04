class ApplicationService
  def self.call(*args, **kws, &blk)
    new(*args, **kws).call(&blk)
  end
end
