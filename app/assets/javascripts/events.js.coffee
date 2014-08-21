$ ->
  $(".datepicker_date").attr({'data-date-format':"MM月DD日"});

  $(".bootstraptimepicker_date").datetimepicker
    language: "ja"
    pickTime: false

  $(".bootstraptimepicker_time").datetimepicker
    language: "ja"
    pickDate: false
    useSeconds: false
    minuteStepping: 15
    defaultDate: '13:00'

  return
