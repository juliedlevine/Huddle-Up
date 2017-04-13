$(document).ready(function() {

    function check(response) {
        if (response === 'match') {
            window.location.href = '/userHome';
        } else if (response === 'not match'){
            swal({
                title: "Error!",
                text: "Passwords do not match",
                type: "error",
                confirmButtonText: "Try again"
            });
        } else if (response === 'fail') {
            swal({
                title: "Error!",
                text: "Try again",
                type: "error",
                confirmButtonText: "Try again"
            });
        } else if (response === 'empty') {
            swal({
                title: "Error!",
                text: "You must fill out all the fields!",
                type: "error",
                confirmButtonText: "Cool"
            });
        } else if (response === 'taken') {
            swal({
                title: "Error!",
                text: "User already exists!",
                type: "error",
                confirmButtonText: "Cool"
            });
        } else if (response === 'successMsg') {
            swal({
                title: "Success!",
                text: "Message posted!",
                type: "success",
                confirmButtonText: "Cool"
            }).then(function() {
                location.reload();
            });
        } else if (response === 'success') {
            swal({
                title: "Success!",
                text: "Event Created",
                type: "success",
                confirmButtonText: "Cool"
            }).then(function() {
                location.reload();
            });
        }

    }



    $('#createMessageButton').click(function(event) {
        event.preventDefault();
        $.ajax({
            url: "/team/addMessage",
            type: "POST",
            data: {
                title: $('.title').val(),
                message: $('.message').val(),
            }
        })
        .then(function(response) {
            check(response);

        })
        .catch(function(err) {
            console.log(err.message);
        });
    });

    $('#submitLogin').click(function(event) {
        event.preventDefault();
        console.log("We are here")
        $.ajax({
            url: "/submitLogin",
            type: "POST",
            data: {
                email: $('.email').val(),
                password: $('.password').val(),
            }
        })
        .then(function(response) {
            console.log('response: ' + response);
            check(response);

        })
        .catch(function(err) {
            console.log(err.message);
        });
    });

    $('#signUpButton').click(function() {
        $.ajax({
            url: "/signUp",
            type: "POST",
            data: {
                first: $('.first').val(),
                last: $('.last').val(),
                email: $('.email').val(),
                cellPhone: $('.cellPhone').val(),
                homePhone: $('.homePhone').val(),
                password: $('.password').val(),
                confirm: $('.confirmPassword').val()
            }
        })
        .then(function(response) {
            check(response);
        })
        .catch(function(err) {
            console.log(err.message);
        });
    });

    $('#createEventButton').click(function(event){
        event.preventDefault();
        $.ajax({
            url: "/team/createEvent",
            type: "POST",
            data: {
                title: $('.title').val(),
                date: $('.date').val(),
                startTime: $('.startTime').val(),
                endTime: $('.endTime').val(),
                location: $('.location').val(),
                comments: $('.comments').val()
            }
        })
        .then(function(response) {
            check(response);
        })
        .catch(function(err) {
            console.log(err.message);
        });
    });

    $('.joinTeamButton').click(function() {
        swal.setDefaults({
          input: 'text',
          confirmButtonText: 'Next &rarr;',
          showCancelButton: true,
          animation: false,
          progressSteps: ['1', '2']
        });
        var steps = [
          {
            title: 'Team Code',
            text: "Enter the code you recieved from your Team's coach."
          },
          {
            title: "Child's Name",
            text: "Enter your child's name."
          },
        ];
        swal.queue(steps).then(function (result) {
            var teamCode = result[0];
            var childName = result[1];
          swal.resetDefaults();
          swal({
            title: 'All done!',
            html:
              'Enjoy the Season!',
            confirmButtonText: 'Great!',
            showCancelButton: false
          }).then(function() {
              swal.resetDefaults();
              $.ajax({
                  url: "/joinTeam",
                  type: "POST",
                  data: {
                      teamCode: teamCode,
                      childName: childName
                  }
              })
              .then(function(response) {
                  check(response);
              })
              .catch(function(err) {
                  console.log(err.message);
              });
            });
          });
      });

    $('#sendGroupTextMessage').click(function(event) {
        event.preventDefault();
        var teamId = $(this).attr('data-team-id');
        sendGroupTextMessage(teamId);
    });

    function sendGroupTextMessage(teamId){
      // var teamId = $(this).attr('data-team-id');
      console.log('teamid: ' + teamId);
      swal({
          title: 'Enter Message to Text the Team',
          input: 'text',
          showCancelButton: true,
          confirmButtonText: 'Submit',
          showLoaderOnConfirm: true,
          allowOutsideClick: false
        })
        .then(function(messageToSend){
          console.log("ok sending the text now");
          console.log("sending: " + messageToSend);
          return $.ajax({
              url: "/sendTextMessage",
              type: "POST",
              data: {
                  teamId: teamId,
                  textMessage: messageToSend
              }
          });
        })
        .then(function (outcome) {
          console.log("sendTextMessage response: " + outcome);
          swal({
            type: 'success',
            title: 'Text message sent!',
          });
        }).
        catch(function(err){
          console.log(err.message);
        });

    }

});
