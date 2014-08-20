$ ->
  $(".datepicker_date").attr "data-format": "yyyy/MM/dd"
  $(".datepicker_time").attr "data-format": "hh:mm"
  $(".bootstraptimepicker_date").datetimepicker
    language: "ja"
    pickTime: false
    startDate: Date.now

  $(".bootstraptimepicker_time").datetimepicker
    language: "ja"
    pickDate: false
    pickSeconds: false
    startDate: Date.now

  return
