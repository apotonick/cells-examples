require "cells"

# --------- simple example with one view and methods being called in the view.

class SongCell < Cell::ViewModel
  self.view_paths = ["../views"]

  def show
    render
  end

private
  def framework
    "Cells"
  end

  def times
    3
  end
end

puts SongCell.new.()



# --------- an example with caching.

class CacheStore < Hash
  def fetch(key, options)
    self[key] and return self[key]
    self[key] = yield
  end
end

CacheStoreInstance = CacheStore.new

class CachingSongCell < Cell::ViewModel
  self.view_paths = ["../views"]

  # if you comment that line, the second call will render the string 10x instead of twice (from cache).
  cache :show

  def show
    render
  end


private
  def times
    model
  end

  def cache_store
    CacheStoreInstance # this could be a redis store or whatever, as long as it responds to the #fetch API.
  end
end

puts CachingSongCell.new(2).()
puts CachingSongCell.new(10).()