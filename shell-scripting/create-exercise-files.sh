#!/usr/bin/env bash

for dir in $(find . -mindepth 1 -maxdepth 1 -type d)
do
    SUBDIR="$dir/practice-exercises"
    if [ -e "$SUBDIR" ]
    then
        i=1
        while [ $i -le $(ls "$SUBDIR" | grep solution-0[[:digit:]].sh | wc -l) ]
        do
            FILENAME="$SUBDIR/exercise-0${i}.sh"

            if [ ! -f $FILENAME ]
            then
                echo '#!/usr/bin/env bash' >> $FILENAME
            fi
            chmod +x $FILENAME

            i=$(($i + 1))
        done
    fi
done
