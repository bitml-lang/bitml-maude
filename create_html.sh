DATE=`date +"%a, %e %b %Y %H:%M"`
TEXT="***\n*** Last update: $DATE\n***\n"

echo -e "$TEXT" | cat - bitml.maude | pygmentize -l pygments_maude.py:MaudeLexer -x -f html -O full=true -o index.html
