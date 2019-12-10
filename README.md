# node-load-generator
build out a nodejs app that can be deployed to beanstalk to help scale very quickly in order to run load tests against an mdb db

NOTE: YOU NEED TO RUN EVERYTHING USING NODE 10.17 AND NOT 11+!!! ASSUMING YOU WANT THE ABILITY TO DEPLOY THIS TO ELASTIC BEANSTALK.

I created a bare bones express route application following the instructions here: https://expressjs.com/en/starter/generator.html
If you clone this github repo then this won't be necessary since everything is already fetched for you.
You may only need to run npm install for missing modules and such which becomes apparent when you try running npm start.

After I set up the barebones express route app, I created a custom router found in routes/demo.js. This router helps define end points and business logic to help test pretty much anything you can write in javascript. The one thing I did was to create a single db connection for the router rather than opening and closing connections for every operation to help prevent the database getting killed with connection handling. The demo.js router shows 2 basic functions of fetching and updating a document along with pseudo code for inserting a document.

After you are done creating your router end points, make sure to update the app.js to include the end points and pass parameters accordingly. Search for "demo" in app.js and you'll see what codes I added.

When you are done coding, you can test locally by executing 'npm start' command. It will tell you to open a browser and hit http://localhost:3000/. Just append your end points to the base url and start testing.

###############################################################

Instructions for deploying to Elastic Beanstalk:
When you are done to push this to Elastic Beanstalk, build the package by running 
     zip -r --exclude=node_modules/* loadgenerator.zip .;mv loadgenerator.zip ../.

I had to create a .npmrc file to get past some node-sass error about making a directory

When configuring EB, you need to select the appropriate security group and pem key access if you want to log into the actual beanstalk nodes to troubleshoot. Otherwise, you can probably do all your troubleshooting just using the download log functionality.

If you are deploying anything other than the free tier t1.micro, you need to create or use an existing VPC
The internet also says to use t3.small or greater because many people have encountered timeout issues due to underpowered instances.
Remove Nginx web server from EB since we are using Express.
Change the npm start command to be npm start else it won't launch the right node process
Make sure to set ALL the environment variables that your routes/demo.js file requires, e.g. SRV=mongodb+srv://<user>:<password>@<srv>/test?retryWrites=true
Lastly, make sure you set up the load balancer option if you want to go beyond a single instance, e.g. heavy duty testing. By default, the load balancer scales periodically every 5 mins. You may want to scale things up to a higher number of nodes if you know you'll need more instances from the start.

One thing to note, when you launch the app to EB, the default port is 80 and not 3000 when running on your local machine. 

Before moving on, open a browser and hit your EB end point to make sure it responds. Just because the AWS console says it's green light doesn't actually mean it's ready. 

###############################################################

Instructions for generating load:

If you want a more refined method with better monitoring and such, use a tool like jmeter and point it to the end points. You'll have better control over the load tests and concurrency and such.

If you want a way to stress test EB, you can run loadmulti.sh which calls load.sh and executes a bunch of curl commands in the background. You will not be maximizing your system resources so I came up with an alternate way calling curl commands using GNU Parallel and batching curl end points. This implementation can be executed using the loadparallel.sh script. Look into each script to get a better idea of how to execute them and what parameters they require. For stress tests, I recommend spinning up vm's with many cores, e.g. md5.24xlarge. Just make sure you terminate the instances when you are done.
