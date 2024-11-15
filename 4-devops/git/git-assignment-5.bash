:<< 'COMMENT'
You have been asked to:
● Create a gitflow workflow architecture on git
● Create all the required branches
● Starting from the feature branch, push the branch to the master, following the architecture
● Push a urgent.txt on master using hotfix
COMMENT

# Create a gitflow workflow architecture on git

# create and initialize git repository
mkdir gitflow_project
cd gitflow_project
git init

# Create all the required branches
git checkout -b develop main 
git checkout -b feature develop 

# Starting from the feature branch, push the branch to the master, following the architecture
git checkout feature # switch to feature branch
touch feature1.txt # create a new file
git add feature1.txt # stage
git commit -m "Add feature1.txt in feature branch" # commit
git push -u origin feature # push to branch

# push feature branch to develop
git checkout develop 
git merge feature -m "Merge feature into develop"
git push origin develop

# push develop branch to main
git checkout main
git merge develop -m "Release new features from develop to main"
git push origin main

# Push a urgent.txt on master using hotfix
git checkout -b hotfix main
touch urgent.txt
git add urgent.txt
git commit -m "Add urgent.txt in hotfix"

git checkout main
git merge hotfix -m "Merge urgent fix into master"
git push origin main
