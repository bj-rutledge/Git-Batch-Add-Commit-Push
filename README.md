# git-add-push-Powershell
A simple script  that batches, adds, commits, and pushes individual files not added to a repo. 

When working on a project that has large assets, github can be a pain. There is a limit of 2GB per push. This script aims to solve that problem. 

It's recommended that you load the script at startup. To do that, you will have to enable scripts and place 
the script in your ~\Documents\WindowsPowershell folder. 

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