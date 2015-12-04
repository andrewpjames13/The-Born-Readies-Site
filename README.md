Big Gulps, huh?
===============

Cool instructions and resources to brighten your day.


##Step 01:

- Download ZIP of this Big Gulps project

- Rename this folder to your project name (i.e. really-cool-site)


##Step 02: Set up your local repository (use terminal or iTerm or something):

- `cd /path/to/your/project`

- `git init`

- `git remote add origin git@bitbucket.org:enterthegrave/big-gulps.git`


##Step 03: Create your first file, commit, and push:

- `echo "Your name or whatever, who cares?" >> contributors.txt`

- `git add contributors.txt`

- `git commit -m 'Initial commit with contributors'`

- `git push -u origin master`


##Step 04: Set up with Gulp, NPM, and Bower:

- Install Gulp globally (if don't have it yet) `npm install -g gulp` (may need to run `sudo npm install -g gulp` depending how your shit is set up)

- Run npm install (only need to do this first time or after you make edits to any npm stuff):

- `npm install`

- Run bower install (only need to do this first time or after you make edits to any bower stuff):

- `bower install`


##Cheat sheet:

- Fire up server and watch with gulp: `gulp`

- Build minifed and concatenated production-ready application: `gulp dist`

- Clean the tmp folder and start over: `gulp clean`