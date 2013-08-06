// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//


//= require jquery
//= require jquery_ujs
//= require_tree .

var scroll_id = 0;

function scroll_to_tweet(id) {

  $("#pl_" + scroll_id).removeClass("current");
  scroll_id = id;
  
  console.log(scroll_id);

  $("#pl_" + id).addClass("current");
	$('html, body').animate({
   	   scrollTop: $("#tt" + id).offset().top - 120
   	}, 'slow');
	
}

function scroll_up() {
  if (scroll_id < 15) {
    scroll_to_tweet(scroll_id+1);
  }
}

function scroll_down() {
  if (scroll_id > 0) {
    scroll_to_tweet(scroll_id-1);
  }    
}

$(document).ready(function (){

    $("a").click(function() {
        var the_id = $(this).attr("href");
        scroll_to_tweet(the_id);
        return false;
    });

	$(document).keydown(function (event) {
  		// handle cursor keys
		 		
		if (event.keyCode == 40) {
        event.preventDefault();  
    		scroll_up();
        return false;
  		} else if (event.keyCode == 38) {
        event.preventDefault();
    		scroll_down();
        return false;
  		}

	});
});

