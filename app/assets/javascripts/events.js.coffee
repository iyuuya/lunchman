$ ->
  $(".datepicker_date").attr({'data-date-format':"YYYY年MM月DD日"});
  #$(".datepicker_time").attr({'data-date-format':"hh:mm"});

  $(".bootstraptimepicker_date").datetimepicker
    #language: "ja"
    pickTime: false

  $(".bootstraptimepicker_time").datetimepicker
    language: "en"
    pickDate: false
    useSeconds: false
    minuteStepping: 15
    defaultDate: '13:00'

  return
