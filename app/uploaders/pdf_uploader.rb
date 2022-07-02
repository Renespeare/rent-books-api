Shrine.plugin :validation_helpers

class PdfUploader < Shrine
    Attacher.validate do
      validate_size      1..100*1024*1024
      validate_mime_type %w[application/pdf]
      validate_extension %w[pdf]
    end
end