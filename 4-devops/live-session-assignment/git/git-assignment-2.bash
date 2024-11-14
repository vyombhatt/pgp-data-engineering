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
git push # push to github

# Create 3 branches develop, feature1 and feature2