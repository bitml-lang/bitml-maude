DATE=`date +"%a, %e %b %Y %H:%M %:z"`
TEXT="***
*** Last update: $DATE
***
*** Github: https://github.com/natzei/bitml-maude/blob/master/bitml.maude
***
"

echo "Creating index.html"
echo -e "$TEXT" | cat - $1/bitml.maude | pygmentize -l $1/pygments_maude.py:MaudeLexer -x -f html -O full=true -o  $1/index.html
