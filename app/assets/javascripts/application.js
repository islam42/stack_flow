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
  $('#question_comment').on("click", function(event) {
    event.preventDefault();
    $('#question_comment_form').show();
    $('#question_comment').hide();
  });

  // hide question comment
  $('#cancel_question_comment').on("click", function(event){
    event.preventDefault();
    $('#question-error-message').empty();
    $('#question-comment-area').val("");
    $('#question_comment_form').hide();
    $('#question_comment').show();
    $('#post-comment').val('post comment');
  });

  // show answer comment area 
  $(document).on("click", 'a[name="answer_comment"]', function (event){
    event.preventDefault();
    answer_id = $(this).attr('answer_id');
    $('#answer-add-comment'+answer_id).hide();
    $('#answer_comment_form'+answer_id).show();
  });

  // hide answer comment area 
  $(document).on("click", 'a[name="cancel_answer_comment"]', function (event){
    event.preventDefault();
    $('#answer-comment-error'+event.target.id).empty();
    $('#answer-comment-area'+event.target.id).val("");
    $('#answer-add-comment'+event.target.id).show();
    $('#answer_comment_form'+event.target.id).hide();
    $('#post-comment'+event.target.id).val('Post comment');
  });

  // activate or deactivated a user
  $('[name="user_status"]').on("change", function(event){
    user_id = event.target.id;
    element_reference = this;
    if($(this).prop('checked') == true)
      status = "activated";
    else
      status = "deactivated";
    $.ajax({
      type: "PUT",
      url: "/users/"+user_id+"/activate_deactivate",
      success: function(resp){
        if (resp == true)
        {
          if(status == "deactivated"){
            alert("User deActivated successfully");
          }
          else{
            alert("User Activated successfully");
          }
        }else{
          alert("Status not modified!");
          $(element_reference).prop('checked', true);
        }
      },error: function(resp) {
        alert("failed! server responed with status code "+resp.status);
      }
    });

  });

  $(document).on('click', 'a[name="edit-comment"]', function(event){
    event.preventDefault();
    id = $(this).attr('id');
    commentable_id = $(this).attr('commentable_id');
    commentable_type = $(this).attr('commentable_type');
    if (commentable_type == "Question")
    {
      $('#question_comment_form').show();
      $('#question_comment').hide();
      $('#question-comment-area').val($(this).attr('body'));
      $('#post-comment').val('update comment');
      $('#new_comment').attr("action", "/comments/"+id);
      $('#new_comment').attr("method", "PUT");
    }
    else if(commentable_type == "Answer")
    {
      $('#answer_comment_form'+commentable_id).show();
      $('#answer-add-comment'+commentable_id).hide();
      $('#answer-comment-area'+commentable_id).val($(this).attr('body'));
      $('#post-comment'+commentable_id).val('update comment');
      $('#answer_comment_form'+commentable_id).find('form').attr("action", "/comments/"+id);
      $('#answer_comment_form'+commentable_id).find('form').attr("method", "PUT");
    }
  });

});
