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
        where parent.id = $1;`,req.session.userId)
        .then(function(results){
            console.log(results);
            res.render('userHome.hbs',{
                teams:results,
                id:results.id
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
        console.log('in redirect userHome');
        // res.redirect('/userHome');
        res.send('match');
    })
    .catch(function(err){
        console.log(err.message);
    });
});

// Team home page route path
app.get('/team/:id', function(req, res, next) {
    let id = req.params.id;
    req.session.teamId = id;
    console.log("team home session id: "+ req.session.teamId);
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
            id:id
        });
    });


});

app.get('/roster/:id', function(req, res, next) {
    let id = req.params.id;
        db.any(`select childname, firstname, lastname, cellphone, homephone, email from childuserteam
        join team
        on team.id = childuserteam.teamid
        join parent
        on parent.id = childuserteam.parent
        where team.id = $1;`, id)
    .then(function(results){
        res.render('roster.hbs', {
            roster: results
        });
    });

    //database query
    //an each in handlebars
    //basic hbs page

});
//
app.get('/events/:id', function(req, res, next) {
    var id = req.params.id;
    db.any(`
        SELECT
        	*
        FROM
        	events
        JOIN
        	team on events.teamid = team.id
        WHERE
        	team.id = $1
        `, id)
    .then(function(results){
        var isCoach = false;
        if (req.session.userId === results[0].coachid){
            isCoach = true;
        }
        res.render('events.hbs', {
            events:results,
            coach: isCoach
        });
    })
    .catch(function(err){
        console.log(err.message);
    });

});

app.get('/messages/:id', function(req, res, next) {
    res.render('messages.hbs', {
        // DATA
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
            res.redirect('/team/' + result.id);
        })
        .catch(next);
});
//
//
// // Form submit - add event (visible to coach) route path
app.post('/team/createEvent', function(req, res, next) {
    var id = req.session.teamId;
    let title = req.body.title;
    let date = req.body.date;
    let startTime = req.body.startTime + ':00';
    let endTime = req.body.endTime + ':00';
    let location = req.body.location;
    let comments = req.body.comments;
    console.log(comments);
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

//
// // Form submit - add message
// app.post('/team/addMessage:id', function(req, res, next) {
//     var id = // FROM SESSION - change session team id when you go to a new team page
//     let sender = req.body.sender;
//     let date = req.body.date;
//     let content = req.body.content;
//     // db.one(`insert into review values (default, $1, $2, $3, $4, $5) returning review.restaurant_id`, [req.session.userId, stars, title, review, id])
//     // NEEDED
//     // same as variables
//         .then(function(result) {
//             res.redirect('/messages/' + id);
//         })
//         .catch(next);
// });


// Start server
app.listen(3000, function() {
    console.log('Example app listening on port 3000!');
});
