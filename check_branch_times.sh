#found at http://www.commandlinefu.com/commands/view/2345/show-git-branches-by-date-useful-for-showing-active-branches
for k in `git branch -a|perl -pe s/^..//`;do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k|head -n 1`\\t$k;done|sort -r
