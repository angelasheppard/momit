# Adapted from https://rubyplus.com/articles/3401-Customize-Field-Error-in-Rails-5
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html = ''

  form_fields = ['textarea', 'input', 'select']

  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, " + form_fields.join(', ')

  elements.each do |e|
    if form_fields.include? e.node_name
      e['class'] += ' is-invalid'
      if instance.error_message.kind_of?(Array)
        html = %(#{e}).html_safe
      end
    end
  end
  html
end