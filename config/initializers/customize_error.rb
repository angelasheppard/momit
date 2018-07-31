# Add Bootstrap 4 CSS class to fields with errors
ActionView::Base.field_error_proc = proc do |html_tag, _instance|
  class_attr_index = html_tag.index 'class="'

  if class_attr_index
    html_tag.insert class_attr_index + 7, 'is-invalid '
  else
    html_tag.insert html_tag.index('>'), ' class="is-invalid"'
  end
end

# Add Bootstrap 4 CSS class to fields with errors, including text below fields
#ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
#  html = ''
#  form_fields = %w(textarea input select)
#  tag_elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, " + form_fields.join(', ')
#
#  tag_elements.each do |e|
#
#    if e.node_name.eql? 'label'
#      html = %(#{e}).html_safe
#    elsif form_fields.include? e.node_name
#      e['class'] = %(#{e['class']} is-invalid)
#      if instance.error_message.kind_of?(Array)
#        field_error_message = instance.error_message.uniq.join(', ')
#      else
#        field_error_message = instance.error_message
#      end
#      html = %(#{e}<div class="invalid-feedback">#{field_error_message}</div>).html_safe
#    end
#
#  end
#
#  html
#
#end
