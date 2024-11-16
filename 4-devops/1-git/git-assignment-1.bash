:<< 'COMMENT'
Based on what you have learnt in the class, do the following steps:
    ● Create a new folder
    ● Put the following files in the folder
        ○ Code.txt
        ○ Log.txt
        ○ Output.txt
    ● Stage the Code.txt and Output.txt files
    ● Commit them
    ● And finally push them to github

Please share the commands for the above points.
COMMENT

# Create a new folder
mkdir Data
cd Data

# Put the following files in the folder
touch Code.txt
touch Log.txt
touch Output.txt

# Initialize git repository
git init

# Stage the Code.txt and Output.txt files
git add Code.txt Output.txt

# Commit them
git commit -m "Initial commit with Code and Output files"

# And finally push them to github
git push