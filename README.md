# git-add-push-Powershell
A simple script  that batches, adds, commits, and pushes individual files not added to a repo. 

When working on a project that has large assets, github can be a pain. There is a limit of 2GB per push. This script aims to solve that problem. 

It's recommended that you load the script at startup. To do that, you will have to enable scripts and place 
the script in your ~\Documents\WindowsPowershell folder. 
### Notes: 
Created by BJ Rutledge 2024-02-28
This tool is for whenever you have a shit ton of files that you need to push to github and you 
can't because the repo is to god-damn big... This works by grabbing the output from git status. 
The script grabs the output of git status, then iterates through the files, creating batches of
less than 2GB, then adding, committing them, and pushing them. 
Each commit will get the same commit message followed by the batch number: 

git commit -m 'My commit message 01' 
git commit -m 'My commit message 02'
...

On testing, I found that, if directories are added to a project 
with a lot of assets, the git status will only return the root 
directory. You will need to manually add the directory BEFORE 
running this script. The script will take it from there. Do not 
add individual files. 
# Usage: 
```
   Push-Repo -Directory . -CommitMessage "My commit message"
```
```
   Push-Repo  . "My commit message"
```
```
pathOutputFromAnotherScript | Push-Repo -CommitMessage "My commit message"
```

As of the writing of this, there is very little error checking and no flags set on the git add, commit, or push. So, 
users will need to make sure that their upstream is set prior to invoking the script. 

Happy coding! 