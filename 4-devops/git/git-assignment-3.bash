:<< 'COMMENT'
● Create a git working directory, with the following branches 
    ○ Develop
    ○ F1 
    ○ f2
● In the master branch, commit main.txt file
● Put develop.txt in develop branch, f1.txt and f2.txt in f1 and f2 respectively
● Push all these branches to github
● On local delete f2 branch
● Delete the same branch on github as well
COMMENT

# Create a git working directory, with the given branches
mkdir git_working_directory
cd git_working_directory
git init

git branch develop
git branch f1
git branch f2


# In the master branch, commit main.txt file
touch main.txt
git add main.txt
git commit -m "Add main.txt to main branch"

# Put develop.txt in develop branch, f1.txt and f2.txt in f1 and f2 respectively
# develop branch
git checkout develop
touch develop.txt
git add develop.txt
git commit -m "Add develop.txt to develop branch"

# f1 branch
git checkout f1
touch f1.txt
git add f1.txt
git commit -m "Add f1.txt to f1 branch"

# f2 branch
git checkout f2
touch f2.txt
git add f2.txt
git commit -m "Add f2.txt to f2 branch"

# Push all these branches to github
git remote add origin https://github.com/vyom_bhattgit-assignment.git

git push -u origin main
git push -u origin develop
git push -u origin f1
git push -u origin f2

# On local delete f2 branch

git branch -d f2

# Delete the same branch on github as well

git push origin --delete f2