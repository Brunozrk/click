$(document).ready(function(){
  $(".timepicker").timepicker({
    showMeridian: false,
    showInputs: false,
    minuteStep: 5,
    defaultTime: false
  }).on('focusout', function(){
    $(this).timepicker("hideWidget");
  });

  $(".datepicker").datepicker({
    format: "dd/mm/yyyy",
    todayBtn: 'linked',
    language: 'pt-BR'
  });

  $('[popover]').popover({ trigger: "hover" });
});
