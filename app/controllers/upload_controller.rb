class UploadController < ApplicationController
  def index
  end

  def upload_file
    post = DataFile.save(params[:upload])
    UploadHelper::upload_file(params[:upload])
    render :text => "Uploaded successfully"
  end
end
