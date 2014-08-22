class ApplicationFormBuilder < ActionView::Helpers::FormBuilder
  def datepicker_date(attribute, options={})
    obejct_name = "%s_date" % [ attribute ]
    id = "%s_%s_date" % [ @object_name, attribute ]
    name = "%s[%s_date]" % [ @object_name, attribute ]
    text_field obejct_name, class: ['form-control', 'datepicker_date'], id: id, name: name, readonly: true
  end

  def datepicker_time(attribute, options={})
    obejct_name = "%s_time" % [ attribute ]
    id = "%s_%s_time" % [ @object_name, attribute ]
    name = "%s[%s_time]" % [ @object_name, attribute ]
    text_field obejct_name, class: ['form-control', 'datepicker_time'], id: id, name: name, readonly: true
  end
end
