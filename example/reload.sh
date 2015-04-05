#!/bin/bash

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function kill_app() {
    echo "Stop application..."
    kill -9 `cat app.pid`
    rm app.pid
}

function ctrl_c() {
    echo "** Trapped CTRL-C"
    kill_app
}

DIRECTORY=$(find ../pyramid_sacrud_pages -type d)

`python app.py& echo $! > app.pid`&

echo "Start application..."
echo

while inotifywait --exclude '\.(pyc)' -e modify $DIRECTORY; do
    kill_app
    `python app.py& echo $! > app.pid`&
    echo "Server restarted..."
    echo
done