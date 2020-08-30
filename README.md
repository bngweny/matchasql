# matchasql
A dating site that allows users to connect with others based on romantic preference/interests and geolocation.

# Matcha
A dating site that allows users to connect with others based on romantic preference/interests and geo location.
Requirements
- npm v6.13.4 : https://www.npmjs.com/get-npm
- Node v12.16.1 : https://nodejs.org/en/download/
- MAMP : https://bitnami.com/stack/mamp / SSMS
# Installation
## How to download the source code
-	Navigate to https://github.com/bngweny/matchasql.git, click on clone or download
-	Once you have downloaded the source code navigate to the folder MatchaSQL
-	run npm install to install all of the modules needed for this project
## How to set up and configure the database
-	Download MAMP from the bitnami website
-	Open the manager-osx. Go to the Manage servers tabs and make sure mysql database is running. If not press Restart.
-	Press configure, this should show details about the port.
-	Open a web browser and go to http://localhost:(the port)/phpmyadmin
-	Create the database titled matcha, navigate to import and upload the file matcha.sql
-	Create a database titled profile, navigate to import and upload the file profile.sql
## How to run the program
-	run node entry to start the server
-	navigate to localhost:3000 in your browser to open the website
## Code Breakdown
###	Back end technologies
-	JavaScript
-	node.js
-	express
###	Front-end technologies
-	ejs
-	bootstrap
-	HTML
-	CSS
###	libraries/modules/dependencies
-	body-parser
-	express-session
###	Database management systems
-	mysql
-	phpmyadmin / ssms
###	Break down of app folder structure
- views
  - chat.ejs
  - completeprofile.ejs
  - find.ejs
  - findlist.ejs
  - home.ejs
  - index.ejs
  - login.ejs
  - passwordreset.ejs
  - profile.ejs
  - user.ejs
  -	partials
    -	head.ejs
    -	scripts.ejs
      - This contains the structure of the nav bar which is consistent throughout application.
- routes
    -	index.js
      -	Handles all the routes that are supported in the application
- controllers
  - homeController.js
  - mediaController.js
  - messageController.js
  - userController.js
- models
  - coordinatesModel.js
  - dataHelper.js
    - auxillary methods to help with data transformation and transfer
  - homeModel.js
  - mediaModel.js
  - messageModel.js
    -	Handles the chat functionality. Ensures that a user is only able to chat with another user if they have both liked each other.
  - notificationsModel.js
    - Handles all notification logic
  - userModel.js
    - Handles all user logic
- config (Contains Configuration for email service)
  - nodemailer.js
- database (Contains database create scripts)
  - StoredProcedures.sql
  - Tables.sql
  - Views.sql
  
- databaseModel.js
   -	Handles the database connection
       
#Testing
https://github.com/wethinkcode-students/corrections_42_curriculum/blob/master/matcha.markingsheet.pdf

