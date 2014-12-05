$(document).ready(function(){
  $(".timepicker").timepicker({
    showMeridian: false,
    showInputs: false,
    minuteStep: 1,
    defaultTime: false
  });

  $(".datepicker").datepicker({
    format: "dd/mm/yyyy",
    todayBtn: 'linked',
    language: 'pt-BR'
  });

  $('[popover]').popover({ trigger: "hover" });
});
