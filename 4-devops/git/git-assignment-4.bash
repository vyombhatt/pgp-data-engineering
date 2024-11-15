:<< 'COMMENT'
● Put master.txt on master branch, stage and commit
● Create 3 branches: public1, public2 and private
● Put public1.txt on public 1 branch, stage and commit
● Merge public 1 on master branch
● Merge public 2 on master branch
● Edit master.txt on private branch, stage and commit
● Now update branch public 1 and public 2 with new master code in private
● Also update new master code on master
● Finally update all the code on the private branch
COMMENT

# Put master.txt on master branch, stage and commit
touch master.txt
git add master.txt
git commit -m "Add master.txt to main branch"

# Create 3 branches: public1, public2 and private
git branch public1
git branch public2
git branch private

# Put public1.txt on public 1 branch, stage and commit
git checkout public1
touch public1.txt
git add public1.txt
git commit -m "Add public1.txt to public1 branch"

# Merge public 1 on master branch
git checkout main
git merge public1 -m "Merge public1 branch into main"

# Merge public 1 on master branch
git merge public2 -m "Merge public1 branch into main"

# Edit master.txt on private branch, stage and commit
git checkout private
echo "Updated content for master text" >> master.txt
git add master.txt
git commit -m "Update master.txt in private branch"

# Now update branch public 1 and public 2 with new master code in private
git checkout public1
git merge private -m "Update public1 branch with new code from private"

git checkout public2
git merge private -m "Update public2 branch with new code from private"

# Also update new master code on master
git checkout main
git merge private -m "Update main branch with new code from private"

# Finally update all the code on the private branch
git checkout private
git merge main -m "Update private branch with latest code from main"
