// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap

$( document ).on('turbolinks:load', function() {

  // show question comment area 
  $('a[name="add_comment"]').on("click", function(event) {
    event.preventDefault();
    id = $(this).attr('id');
    $('#comment_form_div_'+id).show();
    $('#'+id).hide();
  });

  // hide question comment
  $('a[name="cancel_comment"]').on("click", function(event){
    event.preventDefault();
    id = $(this).attr('id');
    $('#comment_error_'+id).empty();
    $('#comment_area_'+id).val("");
    $('#comment_form_div_'+id).hide();
    $('#'+id).show();
    // $('#post_comment').val('post comment');
  });


  $(document).on('click', 'a[name="edit_comment"]', function(event){
    event.preventDefault();
    comment_id = $(this).attr('id');
    commentable = $(this).attr('commentable_type') + $(this).attr('commentable_id');
    $('#comment_form_div_'+commentable).show();
    $('#'+commentable).hide();
    $('#comment_area_'+commentable).val($(this).attr('body'));
    $('#post_comment_'+commentable).val('Update comment');
    $('#comment_form_'+commentable).attr("action", "/comments/"+comment_id);
    $('#comment_form_'+commentable).attr("method", "PUT");
  });

  $('#search-btn').on('click', function(event){
    search_content = $('#search_content').val();
    if (!search_content.trim()){
      event.preventDefault();
      alert('Please enter a valid string to search!');
      $('#search_content').val('');
    }
  });
});
