:<< 'COMMENT'
Do the following tasks:
● Create a git working directory with feature1.txt and feature2.txt in the master branch
● Create 3 branches develop, feature1 and feature2
● In develop branch create develop.txt, do not stage or commit it
● Stash this file, and checkout to feature1 branch
● Create new.txt file in feature1 branch, stage and commit this file
● Checkout to develop, unstash this file and commit
Please submit all the git commands used to do the above steps
COMMENT

# Create a git working directory with feature1.txt and feature2.txt in the master branch

mkdir git_working_directory # creates working dir
cd git_working_directory # move into dir

git init # initialize git

touch feature1.txt feature2.txt # create both the files

git add feature1.txt feature2.txt # move the files to staging

git commit -m "Add feature1.txt and feature2.txt in main branch" # commit to main branch

# Create 3 branches develop, feature1 and feature2

git branch develop
git branch feature1
git branch feature2

# In develop branch create develop.txt, do not stage or commit it
git checkout develop # switch to develop branch
touch develop.txt # create new text file

# Stash this file, and checkout to feature1 branch
git stash push -m "Stash develop.txt in develop branch" # stash the file
git checkout feature1 # switch to feature1 branch

# Create new.txt file in feature1 branch, stage and commit this file
touch new.txt # create new text file
git add new.txt # move it to staging
git commit -m "Add new.txt in feature1 branch" # commit file

# Checkout to develop, unstash this file and commit
git checkout develop # switch to develop
git stash pop # unstash
git add develop.txt # move to staging
git commit -m "Add develop.txt in develop branch" # commit file
