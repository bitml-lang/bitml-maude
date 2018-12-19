rm -r html
mkdir -p html

DATE=`date +"%a, %e %b %Y %H:%M %:z"`

for X in `ls -1 *.maude`; do
    if [ -f $X ]; then
        TEXT="***
*** Last update: $DATE
***
*** Github: https://github.com/natzei/bitml-maude/blob/master/$X
***
"
        extension="${X##*.}"
        filename="${X%.*}"
        echo "Creating $filename.html"
        echo -e "$TEXT" | cat - $1/$X | pygmentize -l $1/pygments_maude.py:MaudeLexer -x -f html -O full=true -o  $1/html/$filename.html
    fi
done

cp html/bitml.html html/index.html