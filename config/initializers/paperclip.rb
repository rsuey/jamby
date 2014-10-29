Paperclip.interpolates(:gravatar_url) do |attachment, style|
  size = nil
  # style should be :tiny, :small, or :regular
  # size_data is assumed to be "16x16#", "20x20#", or "25x25#", i.e., a string
  size_data = attachment.styles[style][:geometry]
  if size_data
    # get the width of the attachment in pixels
    if thumb_size = size_data.match(/\d+/).to_a.first
      size = thumb_size.to_i
    end
  end
  # obtain the url from the model
  # replace nil with "identicon", "monsterid", or "wavatar" as desired
  # personally I would reorder the parameters so that size is first
  # and default is second
  attachment.instance.gravatar_url(nil, size)
end

Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
