require 'twemoji'
require 'twemoji/svg'
require 'html/pipeline/filter'

class HTMLPipelineTwemoji < HTML::Pipeline::Filter
  def call
    Twemoji.parse(doc, file_ext: 'svg', class_name: 'emoji')
  end
end