Shrine.plugin :validation_helpers

class ImageUploader < Shrine
    Attacher.validate do
      validate_size      1..5*1024*1024
      validate_mime_type %w[image/jpeg image/png image/webp]
      validate_extension %w[jpg jpeg png webp]
    end
end