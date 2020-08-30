//Node.js ==> Express Framework (SIMPLE SERVER)
const express = require("express");
let app = express();
//Port to listen on
const PORT = 3000;

const path = require("path");

const bodyParser = require("body-parser");

const bootstrap = require("./src/boostrap");

const ejs = require('ejs');
const session = require('express-session');

var db = require('./src/databaseModel');

var helper = require('./src/models/dataHelper');

//Use a Custom Templating Engine
app.set("view engine", "ejs");

app.set("views", path.resolve("./src/views"));

app.use(session({ secret: 'ssshhhhh', cookie: { secure: false }, resave: false, saveUninitialized: true }));

//Request Parsing
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true, parameterLimit: 1000000 }));
//Create Express Router
const router = express.Router();
app.use(router);

const rootPath = path.resolve("./dist");
app.use(express.static(rootPath));
var sess;

bootstrap(app, router);

//Main Page (Home)
router.get("/", (req, res, next) => {
  sess = req.session;
  sess.username = "myname its";
  // return res.send("Hello There");
  return res.render('index', {error: null});
});

router.use((err, req, res, next) => {
  if (err) {
    //Handle file type and max size of image
    return res.send(err.message);
  }
});

async function func()
{
  let temp =  console.log(helper.userData((await db.getUsersbySexualPreference('both'))))
}

app.listen(PORT, err => {
  if (err) return console.log(`Cannot Listen on PORT: ${PORT}`);
  console.log(`Server is Listening on: http://localhost:${PORT}/`);
//  func();
});
/*
db.connect('mongodb://bngweny:1am!w2k@ds117334.mlab.com:17334/matcha', (err) => {
  if (err) {
    console.log("cant conenct to DB");
  }
  else {
    app.listen(PORT, err => {
      if (err) return console.log(`Cannot Listen on PORT: ${PORT}`);
      console.log(`Server is Listening on: http://localhost:${PORT}/`);
    });
  }
});*/