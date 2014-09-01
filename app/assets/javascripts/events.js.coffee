$(document).on 'ready page:load', ->
  $(".datepicker_date").attr({'data-date-format':"YYYY年MM月DD日"});

  now = new Date()
  y = now.getFullYear()
  m = now.getMonth()
  d = now.getDate()

  tomorrow = new Date(y, m, d + 1)
  t_y = tomorrow.getFullYear()
  t_m = tomorrow.getMonth() + 1
  t_d = tomorrow.getDate()
  t_m = "0" + t_m if t_m < 10
  t_d = "0" + t_d if t_d < 10
  t_date_string = t_y + "年" + t_m + "月" + t_d + "日"


  $(".bootstraptimepicker_date").datetimepicker
    pickTime: false
    defaultDate: t_date_string

  $(".bootstraptimepicker_time").datetimepicker
    language: "en"
    pickDate: false
    useSeconds: false
    minuteStepping: 15
    defaultDate: '13:00'
