class DataFile < ActiveRecord::Base
  attr_accessor :upload
  def self.save(upload)
    title = upload[:dataFile].original_filename
    path = File.join('public/data', title)
    File.open(path, "wb") { |f| f.write(upload[:dataFile].read) }
  end
end
