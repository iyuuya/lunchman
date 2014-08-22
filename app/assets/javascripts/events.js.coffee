$ ->
  $(".datepicker_date").attr({'data-date-format':"YYYY年MM月DD日"});

  $(".bootstraptimepicker_date").datetimepicker
    pickTime: false

  $(".bootstraptimepicker_time").datetimepicker
    language: "en"
    pickDate: false
    useSeconds: false
    minuteStepping: 15
    defaultDate: '13:00'
