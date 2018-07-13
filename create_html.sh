DATE=`date +"%a, %e %b %Y %H:%M %:z"`
TEXT="***\n*** Last update: $DATE\n***\n"

echo "Creating index.html"
echo -e "$TEXT" | cat - $1/bitml.maude | pygmentize -l $1/pygments_maude.py:MaudeLexer -x -f html -O full=true -o  $1/index.html
