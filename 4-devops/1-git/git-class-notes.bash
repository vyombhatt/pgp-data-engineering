#####################################################################################
# Git Codes on AWS EC2
#####################################################################################

# Launch AWS EC2 terminal

# Check if git is installed
git --version

# install git 
sudo yum install -y git
# sudo: admin access; yum: aws package manager; -y: passing yes parameter

# create new directory
mkdir gitdemo
cd gitdemo/
ls -al

# Add git credentials to config - any commits made will be assigned to this name
git config --global user.name "username"
git config --global user.email "git_email@example.com"
git config --list # check the config added

# First command to use git
git init # This command converts a regular directory to a git directory
ls -al # a hidden .git folder will be created now 

# create a new file in gitdemo
vi demo.txt # creates demo.txt and opens editor, then press [Esc + i] to change to edit mode
# Enter the text in the file once in edit mode
# [Esc + [Ctrl+C]] to save the changes made
# To save and exit, type [:wq]
cat demo.txt # to view the text written in the file

# Accoring to the git workflow, there are 3 stages: working directory, staging area, local repository
git status # Currently, the file is in our sorking directory

git add demo.txt # moves the file to staging area
git commit -m "my first commit" demo.txt # moves the file from staging area to commit area

git log # Gives the log of all commits, with commit ID, author details and timestamp

# Now if we make any changes to the existing code, git will be able to understand that changes have been made
# Then we need to move the file to staging area again, and commit again

git show {commit-id} # To show the changes made in the commit
git show 4d730b3a0e1ef7ba21b4c967f968b93b9494bb3a

# Since this commit-id is long, we can use a shortened version of it
git log --oneline # will show the logs with just the first 7 characters of the commit-id
git show 4d730b3 # the first 7 characters of commit-id are enough to work with
git log --stat # shows all details for every commit made

# If the changes have not been pushed to staging area, we can check for changes made to file
vi demo.txt # --> make an edit
git diff demo.txt # will compare the current version with last commited version

# If the changes  have been moved to staging area using git add., we can check changes using
git diff --cached

git restore # Will remove all the changes made in the working directory, bring the directory to last commit status

# Since the commit id's are very long, we can create Tags for every commit to refer to them instead
# There are 2 types of tags: lightweight tags, annotated tags
git tag # lists all existing tags
git tag v1.1.0 # lightweight tag: this assigns tag: v1.1.0 to the latest commit
git tag -a v1.1.0 -m "Released new v1.1.0" # annotated tag provides additional description to the tag

git tag v1.0.0 {commit-id} # assigning a tag to an older commit 
git tag v1.0.0 5e736c3

# After creating the tag, we can now perform git show using tag-id instead of commit-id
git show {tag-id}
git show v1.1.0

# To delete the tag
git tag -d v1.1.0

# We can make git ignore files that don't need to be commited
# E.g. let's say we want to ignore all csv files
vi .gitignore # first create a .gitignore file
# inside the file, insert *.csv and save the file
# Now any .csv files made in the working directory will not be considered when moving files to staging or commit

# Git hooks: these are scripts that can be made to be executed before or after commits
# These can be in form of bash scripts

# To move between branches
git checkout {branch-name}

# Git Stash  used mainly when we want to move between branches
# this will remove the changed file from the working directory and save them in the  git memory
git stash # for stashing files in the staging area
git stash -u # for stashing untracked files in working directory

git stash list # shows list of stashed files, along with stash id

git stash apply # this will bring back the stashed file, but it will also keep the file in the git stash memory
git stash pop # this will bring back the stashed file and remove it from the stash memory
git stash pop {stash-id} # we can bring back specific stashed items too by passing stash-id

# Undoing Git Commits
# This can be done using 2 commands: revert, reset
git log --oneline # lists all commits
git revert {commit-id} # this will remove all the changes made in the given commit id
# Revert undoes the commit, but it generates a new commit id with this change. 
# Which means we can get back those changes, hence git revert is safer than git reset
git reset {commit-id} # this will remove changes made after this commit id, points the HEAD to this commit id 
# This cannot be retrieved as git reset does not create a new commit
git reset --hard {commit-id} # undoes the commit, permanently removes all files
git reset --soft {commit-id} # undoes the commit, but moves the untracked files to staging area
git reset --mixed {commit-id} # undoes the commit, but moves the untracked files to working directory

##
#### Connecting your working directory wit a github repository

# There are 2 ways to connect to a github repo: using SSH or Personal Access Token (PAT)
# Here we use PAT
# On Github, Settings -> Developer Settings -> Personal Access Tokens -> Token (classic)
# Enter details, select admin privileges, generate the token ID and save the token ID
# token ID: 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

# Firstly we need to change the base branch of our ec2 system from "master" to "main"
# This is because the base branch on github is called "main"
git branch -m main # changes branch name fro master to main
git branch # to check the branch name

# To check if there are any remote repository added to your local system
git remote -v

# Add the repository to the ec2 remote repos, this step can only be done after generating the PAT
git remote add origin https://github.com/vyombhatt/pgp-data-engineering.git

git pull --rebase origin main # One time run that pulls all the files from existing repo
git push -u origin main # Command to push latest commit to github
# Above command requires Username: enter email/name, Password: PAT

git fetch # downloads all files from github, but they are not synced with local working directory
git diff main origin/main # this command is followed after the fetch command
# This compares the local directory main, with remote dir origin/main. 
# All files where changes are observed by the fetch command can be seen here. 
# To merge them working dir, run git pull

git pull # smarter verion, identifies files where changes are made, pulls the changes and syncs existing files

# Create a working directory that is a copy of an existing github repository
git clone {github-repo-url} # can be used in a directory without a .git folder also

# Merging files across multiple branches
git merge {branch-name} # will merge 2 branches without hampering the commit history (based on timestamp)
git rebase {branch-name} # will merge the 2 branches, but the commit history will be hampered.
# In rebased commit history, it shows all commits of 1 branch followed by the other, without considering timestamp
# Hence, always prefer git merge

# Handling merge conflicts, if any, after pulling codes