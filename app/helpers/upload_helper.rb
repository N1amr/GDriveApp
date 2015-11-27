# dir = File.join(Rails.root,'lib/google/')
# require(dir+"/api.rb")
# require(dir+"/files.rb")

module UploadHelper
    def self.upload_file(upload)
        fman = GDrive::FileManager.new()

        title = upload[:dataFile].original_filename
        dir = Dir.new('public/data/')
        path = File.join('public/data/', title)
        File.open(path, "wb") { |f| f.write(upload[:dataFile].read) }
        fman.upload_file(path, title, title, "image/jpg", nil)
    end
end
