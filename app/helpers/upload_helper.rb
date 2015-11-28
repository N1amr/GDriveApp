require File.join(Rails.root,'lib/google/files')
require File.join(Rails.root,'lib/google/api')

module UploadHelper
    def self.upload_file(upload, mime_type = "image/jpg")
        fman = GDrive::FileManager.new()

        title = upload[:dataFile].original_filename
        dir = Dir.new('public/data/')
        path = File.join('public/data/', title)
        File.open(path, "wb") { |f| f.write(upload[:dataFile].read) }

        mime_type = "text/plain" if /^.*\.t[e]*xt/ === title
        fman.upload_file(path, title, title, mime_type, nil)
    end
end
