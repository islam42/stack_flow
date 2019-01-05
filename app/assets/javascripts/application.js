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
  $('#question_comment').click(function(event) {
    event.preventDefault();
    $('#question_comment_form').show();
    $('#question_comment').hide();
  });

  // hide question comment
  $('#cancel_question_comment').click(function(event){
    event.preventDefault();
    $('#question_comment_form').hide();
    $('#question_comment').show();
  });

  // show answer comment area 
  $('a[name="answer_comment"]').click(function (event){
    event.preventDefault();
    $('#answer_comment_form'+event.target.id).show();
  });
  // hide answer comment area 
  $('a[name="cancel_answer_comment"]').click(function (event){
    event.preventDefault();
    $('#answer_comment_form'+event.target.id).hide();
  })

  // upvote  for question
  $('#upvote_question').click(function(event){
    question_id = $(this).attr('name');
    if($(this).attr('class') == 'arrow-up')
    {
      url = "/questions/"+question_id+"/upvote";
    }else{
      url = "/questions/"+question_id+"/downvote";
    }
    $.ajax({
      type: "PUT", 
      url: url,
      success: function(resp){
        $('#question_votes_count').text(resp)
      }
    })
    event.target.classList.toggle('on');
  })

  // downvote for question
  $('#downvote_question').click(function(event){
    question_id = $(this).attr('name');
    if($(this).attr('class') == 'arrow-down')
    {
      url = "/questions/"+question_id+"/downvote";
    }else{
      url = "/questions/"+question_id+"/upvote";
    }
    $.ajax({
      type: "PUT", 
      url: url,
      success: function(resp){
        $('#question_votes_count').text(resp)
      }
    })
    event.target.classList.toggle('on');
  })

  // upvote for answer
  $('div[name="upvote_answer"]').click(function(event){
    answer_id = event.target.id;
    question_id = $(this).attr('question_id');
    if($(this).attr("class") == "arrow-up")
    {
      url = "/questions/"+question_id+"/answers/"+answer_id+"/upvote";
    }
    else{
      url = "/questions/"+question_id+"/answers/"+answer_id+"/downvote";
    }
    $.ajax({
      type: "PUT",
      url: url,
      success: function(resp){
        $('#answer_votes_count'+answer_id).text(resp)
      }
    })
    event.target.classList.toggle('on');
  })
  // downvote for answer
  $('div[name="downvote_answer"]').click(function(event){
    answer_id = event.target.id;
    question_id = $(this).attr('question_id');
    if($(this).attr("class") == "arrow-down")
    {
      url = "/questions/"+question_id+"/answers/"+answer_id+"/downvote";
    }
    else{
      url = "/questions/"+question_id+"/answers/"+answer_id+"/upvote";
    }
    $.ajax({
      type: "PUT",
      url: url,
      success: function(resp){
        $('#answer_votes_count'+answer_id).text(resp)
      }
    })
    event.target.classList.toggle('on');
  })

  // Marking answer as correct 
  $('[name="mark_answer"]').click(function(event){
    answer_id = event.target.id;
    question_id = $(this).attr('question_id');
    element_reference = this;
    if($(this).attr("class") == "correct")
    {
      status = "incorrect";
      url = "/questions/"+question_id+"/answers/"+answer_id+"/accept";
    }
    else{
      status = "correct"
      url = "/questions/"+question_id+"/answers/"+answer_id+"/reject";
    }
    $.ajax({
      type: "PUT",
      url: url,
      success: function(resp){
        if(resp == true)
          if(status == "incorrect") 
          {
            alert("marked as correct successfully");
            $(element_reference).addClass('on');
          }
          else{
            alert("marked as incorrect successfully");
            $(element_reference).removeClass('on');
          }
        }
     })
  });

  // activate or deactivated a user
  $('[name="user_status"]').change(function(event){
    user_id = event.target.id;
    if($(this).prop('checked') == true)
      status = "activated"
    else
      status = "deactivated"
    $.ajax({
      type: "PUT",
      url: "/users/"+user_id+"/activate_deactivate",
      success: function(resp){
        if (resp == true)
        {
          if(status == "deactivated"){
            alert("User deActivated successfully")
          }
          else{
            alert("User Activated successfully")
          }
        }else{
          alert("Admin status can't be modified!")
        }
      },error: function(response){
        alert("Internal error!")
      }
    })

  })

})

