#!/bin/sh

CLIST=$(docker ps -qa)
if [ "x"$CLIST == "x" ]; then
  echo "No containers exist - skipping container cleanup"
else
  docker rm -f $CLIST
fi

ILIST=$(docker images -a -q)
if [ "x"$ILIST == "x" ]; then
  echo "No images exist - skipping image cleanup"
else
  docker rmi $ILIST
fi

VLIST=$(docker volume ls -q)
if [ "x"$VLIST == "x" ]; then
  echo "No volumes exist - skipping volume cleanup"
else
  docker volume rm -f $VLIST
fi
