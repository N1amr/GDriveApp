class UploadController < ApplicationController
  def index
  end

  def upload_file
    post = DataFile.save(params[:upload])
    render :text => "Uploaded successfully"
  end
end
