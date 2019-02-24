$(document).ready(function(){
    $(".hidden_about").click(function(){
//       $(".show_about").css("display", "block");
//       $(".main_part").css("display", "none");
        $(".main_part").hide();
        $("#card").hide();
        $(".show_about").fadeIn(1000);
        $("#card").slideDown(1000);

    });
    $(".close_about").click(function(){
//       $(".show_about").css("display", "none");
//        $(".main_part").css("display", "block");
        $(".show_about").hide();
        $(".main_part").slideDown(2000);
    });
});
