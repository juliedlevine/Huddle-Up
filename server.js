/*jshint esversion: 6 */
const express = require('express');
const app = express();
var Promise = require('bluebird');
var pgp = require('pg-promise')({promiseLib: Promise});
const bodyParser = require('body-parser');
const db = pgp({
  host: 'localhost',
  database: 'huddleUp',
});
const session = require('express-session');
const bcrypt = require('bcrypt');
var twilioConfig = require('./config/twilio-config.js');
var twilioClient = twilioConfig.twilioClient;
app.set('view engine', 'hbs');
app.use(session({
    secret: 'hippo1234',
    cookie: {
        maxAge: 600000000}
}));


// Serve up public files at root
app.use(express.static('public'));

// Add to request object the body values from HTML
app.use(bodyParser.urlencoded({extended: false}));

// Make session automatically available to all hbs files
app.use(function(req, res, next) {
    res.locals.session = req.session;
    next();
});

// Home page / Log in
app.get('/', function(req, res) {
    res.render('homePage.hbs');
});

// Sign up
app.get('/signUp', function(req, res) {
    res.render('signUp.hbs');
});

// Log out
app.get('/logout', function(req, res) {
    req.session.user = null;
    req.session.userId = null;
    req.session.teamId = null;
    res.redirect('/');
});

// Submit Log in details, click button on home page
app.post('/submitLogin', function(req, res, next) {
    var email = req.body.email;
    var password = req.body.password;
    db.one("SELECT id, firstname, email, password FROM parent WHERE email ilike $1", email)
        .then(function(loginDetails) {
            return [loginDetails, bcrypt.compare(password, loginDetails.password)];
        })
        .spread(function(loginDetails, matched) {
            if (matched) {
                req.session.user = loginDetails.firstname;
                req.session.userId = loginDetails.id;
                res.send('match');
            } else {
                res.send('fail');
            }
        })
        .catch(function(err) {
            console.log(err.message);
            res.send('fail');
        });
});

// Sign up, click sign up submit button route
app.post('/signUp', function(req, res, next) {
    var first = req.body.first;
    var last = req.body.last;
    var email = req.body.email;
    var cellPhone = req.body.cellPhone;
    var homePhone = req.body.homePhone;
    var password = req.body.password;
    var confirm = req.body.confirm;
    if (email === '' || password === '' || confirm === '' || first === '' || last === '' || cellPhone === '') {
        res.send('empty');
    } else if (password !== confirm) {
        res.send('not match');
    } else {
        bcrypt.hash(password, 10)
            .then(function(encrypted) {
                return db.one("INSERT into parent values (default, $1, $2, $3, $4, $5, $6) returning parent.id as id", [first, last, cellPhone, homePhone, encrypted, email]);
            })
            .then(function(result) {
                req.session.user = first;
                req.session.userId = result.id;
                res.send('match');
            })
            .catch(function(err) {
                console.log(err.message);
                res.send('fail');
            });
    }
});

// Authenticate log in
app.use(function authentication(req, res, next) {
    if (req.session.user) {
        next();
    } else {
        res.redirect('/');
    }
});

// User home
app.get('/userHome', function(req, res) {
    db.any(`
        select distinct teamname, team.id
        from team
        join childuserteam
        on team.id = childuserteam.teamid
        join parent
        on childuserteam.parent = parent.id
        where parent.id = $1 and team.coachid != $1;`,req.session.userId)
        .then(function(childresult){
          return [childresult, db.any(`select distinct teamname, team.id
          from
          team
          where coachid = $1`, req.session.userId)];
        })
        .spread(function(childresults, coachresults) {
            res.render('userHome.hbs', {
                teams: childresults,
                id: childresults.id,
                coachteams: coachresults,
                coachid: coachresults.id
            });
        })
        .catch(function(err){
            console.log(err.message);
        });
});

// Create team
app.get('/createTeam', function(req, res) {
    res.render('createTeam.hbs');
});

// Join a team path
app.post('/joinTeam', function(req, res) {
    var teamCode = req.body.teamCode;
    var childName = req.body.childName;
    db.one(`select team.id from team where team.teamCode =      $1`,teamCode)
    .then(function(teamid){
        return db.none(`insert into childuserteam values($1,$2,$3, default);`,[req.session.userId, teamid.id, childName]);
    })
    .then(function(){
        res.send('match');
    })
    .catch(function(err){
        console.log(err.message);
    });
});

// Team Home page
app.get('/team/:id', function(req, res, next) {
    let id = req.params.id;
    req.session.teamId = id;
    db.one(`
        select teamname, coachid, description,teamcode, astcoach, parent.firstname, parent.lastname
        from team
        left outer join parent on coachid = parent.id
        where team.id =$1;`, id)
    .then(function(results){
        var isCoach = false;
        if (req.session.userId === results.coachid){
            isCoach = true;
        }
        res.render('teamHome.hbs', {
            team: results.teamname,
            description: results.description,
            teamcode: results.teamcode,
            astcoach: results.astcoach,
            coachFirst: results.firstname,
            coachLast: results.lastname,
            coach: isCoach,
            id: id
        });
    });

});

// Team Roster
app.get('/roster/:id', function(req, res, next) {
    let id = req.params.id;
        db.any(`select team.teamname, childname, firstname, lastname, cellphone, homephone, email
        from team
        left outer join childuserteam
        on team.id = childuserteam.teamid
        left outer join parent
        on parent.id = childuserteam.parent
        where team.id = $1;`, id)
    .then(function(results){
        res.render('roster.hbs', {
            team: results[0].teamname,
            roster: results
        });
    });

});

// Team Events page
app.get('/events/:id', function(req, res, next) {
    var id = req.params.id;
    db.one(`SELECT teamname, coachid FROM team WHERE team.id = $1`, id)
        .then(function(teamInfo) {
            return [teamInfo, db.any(`SELECT * FROM events JOIN team on events.teamid = team.id WHERE team.id = $1`, id)];
        })
        .spread(function(teamInfo, results) {
            results.forEach(function(item){item.date = item.date.toDateString();item.starttime = fixTime(item.starttime);item.endtime = fixTime(item.endtime);});
            var isCoach = false;
            if (req.session.userId === teamInfo.coachid) {
                isCoach = true;
            }
            res.render('events.hbs', {
                teamName: teamInfo.teamname,
                events: results,
                coach: isCoach
            });
        })
        .catch(function(err){
            console.log(err.message);
        });
});

// Team Messages page
app.get('/messages/:id', function(req, res, next) {
    var id = req.params.id;
    db.one(`select teamname from team where team.id = $1`, id)
        .then(function(teamName) {
            return [teamName, db.any(`SELECT * FROM messages JOIN team on messages.teamid = team.id join parent on parent.id = messages.sender WHERE team.id = $1`, id)];
        })
        .spread(function(teamName, results) {
            results.forEach(function(item){item.date = item.date.toDateString();item.time = fixTime(item.time);});
            res.render('messages.hbs', {
                teamName: teamName.teamname,
                messages: results
            });
        })
        .catch(function(err){
            console.log(err.message);
        });
});

// Form Submit - add new team route path
app.post('/team/submitNew', function(req, res, next) {
    let teamName = req.body.teamName;
    let category = req.body.category;
    let astCoach = req.body.astCoach;
    let description = req.body.description;
    function genCode() {
        var alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        var code = '';
        for (var i = 0; i <= 7; i++) {
            var r = getRandomIntInclusive(0, 25);
            if (i === 3 || i === 5){
                code += '-';
            }
            code += alphabet[r];
        }
        function getRandomIntInclusive(min, max) {
            min = Math.ceil(min);
            max = Math.floor(max);
                return Math.floor(Math.random() * (max - min + 1)) + min;
            }
                return code;
    }
    let teamCode = genCode();
    db.one("insert into team values(default, $1, $2, $3, $4, $5) returning team.id as id", [teamName, req.session.userId, astCoach, teamCode, description])
        .then(function(result) {
            var response = {
                message: 'successTeam',
                id: result.id
            };
            res.send(response);
        })
        .catch(next);
});

// Form submit - add new event (visible to coach) route path
app.post('/team/createEvent', function(req, res, next) {
    var id = req.session.teamId;
    let title = req.body.title;
    let date = req.body.date;
    let startTime = req.body.startTime + ':00';
    let endTime = req.body.endTime + ':00';
    let location = req.body.location;
    let comments = req.body.comments;
    db.none(`
    insert into events values(
    default, $1, $2, $3, $4, $5, $6, $7)`,[title, date, startTime, endTime, location, comments, id])
    .then(function(result) {
        res.send('success');
    })
    .catch(function(err){
        console.log(err.message);
        res.send('fail');
    });
});

// Form submit - add new message route path (visible to all)
app.post('/team/addMessage', function(req, res, next) {
    let id = req.session.teamId;
    let sender = req.session.userId;
    let title = req.body.title;
    let message = req.body.message;
    db.none(`insert into messages values (default, $1, $2, $3, $4, default, default)`, [sender, title, message, id])
        .then(function() {
            res.send('successMsg');
        })
        .catch(next);
});

// Ajax request to send a Team Text Message
app.post('/sendTextMessage', function(req, res) {
    var teamId = req.body.teamId;
    var textMessage = req.body.textMessage;
    var testNumbers = ['+14049315804','+14049315804'];
    testNumbers.forEach(function(cellPhoneNumber){
      twilioClient.sms.messages.create({
          to:cellPhoneNumber,
          from:'+16786662282',
          body: textMessage
      }, function(error, message) {

          if (!error) {
              // res.send('success');
              console.log('Success! The SID for this SMS message is:');
              console.log(message.sid);
              console.log('Message sent on:');
              console.log(message.dateCreated);
          } else {
              console.log('Oops! There was an error.');
              // res.send('failure');
          }
      });

    });
    res.send('success');

});

function fixTime(time){
  var hours = parseInt(time.substring(0,2));
  var period = " AM";
  if (hours > 12){
    period = " PM";
    hours = hours - 12;
  }

  time = hours + ":" + time.substring(3,5) + period;
  return time;

}

// Start server
app.listen(3000, function() {
    console.log('Example app listening on port 3000!');
});
