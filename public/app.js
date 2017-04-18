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
        } else if (response.message === 'successTeam') {
            swal({
                title: "Success!",
                text: "Team Created!",
                type: "success",
                confirmButtonText: "Cool"
            }).then(function() {
                var teamId = response.id;
                window.location.href = '/team/' + teamId;
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

    // Submit login button click
    $('.submitLogin').click(function(event) {
        event.preventDefault();
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

    // Submit login dropdown button click
    $('.submitLoginDropdown').click(function(event) {
        event.preventDefault();
        $.ajax({
            url: "/submitLogin",
            type: "POST",
            data: {
                email: $('.emailDropdown').val(),
                password: $('.passwordDropdown').val(),
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

    // Sign up button click
    $('.signUpButton').click(function(event) {
        event.preventDefault();
        console.log('Clicked sign up button.');
        $.ajax({
            url: "/signUpInsert",
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

    // Create event button click
    $('#createEventButton').click(function(event){
        event.preventDefault();
        swal({
        title: 'Add a new Event',
        imageUrl: '/cal.png',
        imageWidth: 100,
        imageHeight: 100,
        showCancelButton: true,
        html:
            '<p class="swalLabel">Title:</p>' +
            '<input type="text" id="" name=" title" id="eventTitle" class="swal2-input title">' +
            '<p class="swalLabel">Date:</p>' +
            '<input type="text" name="date" id="eventDate" class="swal2-input date">' +
            '<p class="swalLabel">Start Time:</p>' +
            '<input type="text" id="eventStartTime" class="timepicker swal2-input startTime">' +
            '<p class="swalLabel">End Time:</p>' +
            '<input type="text" id="eventEndTime" class="timepicker swal2-input endTime">' +
            '<p class="swalLabel">Location:</p>' +
            '<input type="text" id="swal-input1" name="location" id="eventText" class="swal2-input location">' +
            '<p class="swalLabel">Comment:</p>' +
            '<input type="text" id="swal-input1" name="comments" id="eventComment" class="swal2-input comments">',
        onOpen: function(){
          $("#eventDate").datepicker();
          $('#eventStartTime').timepicker({
                timeFormat: 'h:mm p',
                interval: 15,
                minTime: '8:00am',
                maxTime: '10:00pm',
                defaultTime: '9:00am',
                startTime: '9:00am',
                dynamic: false,
                dropdown: true,
                scrollbar: true,
                zindex: 1100
          });
          $('#eventEndTime').timepicker({
                timeFormat: 'h:mm p',
                interval: 15,
                minTime: '10',
                maxTime: '6:00pm',
                defaultTime: '11',
                startTime: '10:00',
                dynamic: false,
                dropdown: true,
                scrollbar: true,
                zindex: 1100
          });
        }

        }).then(function() {
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
        }).catch(function(err) {
          console.log(err.message);
        });

    });

    // Join team button click
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

    // Send group text message button click
    $('#sendGroupTextMessage').click(function(event) {
        event.preventDefault();
        var teamId = $(this).attr('data-team-id');
        sendGroupTextMessage(teamId);
    });

    // Send group text message function call
    function sendGroupTextMessage(teamId){
      // var teamId = $(this).attr('data-team-id');
      console.log('teamid: ' + teamId);
      swal({
          title: 'Send a Text Message to your Team',
          text: 'Enter message below',
          input: 'textarea',
          imageUrl: '/chat.png',
          imageWidth: 100,
          imageHeight: 100,
          animation: false,
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

    // Add message button click
    $('#createMessageButton').click(function() {
        swal({
        title: 'Add a new Message',
        showCancelButton: true,
        imageUrl: '/chat.png',
        imageWidth: 100,
        imageHeight: 100,
        html:
            '<p class="swalLabel">Title:</p>' +
            '<input id="swal-input1" class="swal2-input title">' +
            '<p class="swalLabel">Message:</p>' +
            '<input id="swal-input2" class="swal2-input message">'
        }).then(function() {
            $.ajax({
                url: "/team/addMessage",
                type: "POST",
                data: {
                    title: $('.title').val(),
                    message: $('.message').val()
                }
            })
            .then(function(response) {
                check(response);
            })
            .catch(function(err) {
                console.log(err.message);
            });
      }).catch(function(err) {
          console.log(err.message);
      });
    });

    // Create Team button click
    $('#createTeamButton').click(function() {
        swal.resetDefaults();
        swal({
        title: 'Create a Team',
        showCancelButton: true,
        imageUrl: '/jersey.png',
        imageWidth: 100,
        imageHeight: 100,
        html:
            '<p class="swalLabel">Team Name:</p>' +
            '<input id="swal-input1" class="swal2-input teamName">' +
            '<p class="swalLabel">Category:</p>' +
            '<input id="swal-input1" class="swal2-input category">' +
            '<p class="swalLabel">Assistant Coach:</p>' +
            '<input id="swal-input1" class="swal2-input astCoach">' +
            '<p class="swalLabel">Description: </p>' +
            '<input id="swal-input1" class="swal2-input description">'
        }).then(function() {
            $.ajax({
                url: "/team/submitNew",
                type: "POST",
                data: {
                    teamName: $('.teamName').val(),
                    category: $('.category').val(),
                    astCoach: $('.astCoach').val(),
                    description: $('.description').val()
                }
            })
            .then(function(response) {
                check(response);
            })
            .catch(function(err) {
                console.log(err.message);
            });
      }).catch(function(err) {
          console.log(err.message);
      });
    });

    $('#eventDate').datepicker();
});
