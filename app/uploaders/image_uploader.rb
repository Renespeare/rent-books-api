Shrine.plugin :validation

class ImageUploader < Shrine
    Attacher.validate do
      validate_max_size      1*1024*1024
      validate_mime_type %w[image/jpeg image/png image/webp]
    #   validate_extension %w[jpg jpeg png webp]
    end
end