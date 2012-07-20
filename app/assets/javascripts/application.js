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

;(function( window, document ) {
  var HaxxorNews = {
    voting: {
      updatePoints: function($votable, newPoints){
        $votable.find('.points').text(newPoints);
      },
  
      removeVotingForms: function($votable){
        $votable.find('.btn-group').remove();
      }
    }
  };

  $(document).ready(function(){
    $('form.voting').on("ajax:success", function(event, data){
      var $votable = $(this).closest('.votable');
      HaxxorNews.voting.removeVotingForms($votable);
      HaxxorNews.voting.updatePoints($votable, data.points);
    });
  });
})(window, document);
