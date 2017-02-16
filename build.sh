#!/usr/bin/env bash

ORIGINAL_DOCKERFILE=Dockerfile.php.original
ADDON_DOCKER_FILE=Dockerfile.addon
TAG=`date +"%Y-%m-%d-%H-%M-%S"`

curl -o ${ORIGINAL_DOCKERFILE} https://raw.githubusercontent.com/docker-library/php/9abc1efe542b56aa93835e4987d5d4a88171b232/7.1/fpm/Dockerfile

# Thanks to http://stackoverflow.com/questions/10107459/replace-a-word-with-multiple-lines-using-sed
DATA="$(cat ${ADDON_DOCKER_FILE})"
ESCAPED_DATA="$(echo "${DATA}" | sed ':a;N;$!ba;s/\n/\\n/g' | sed 's/\$/\\$/g')"
cat ${ORIGINAL_DOCKERFILE} | sed 's~EXPOSE 9000~'"${ESCAPED_DATA}"'~' > Dockerfile

#sed -i 's/www-data/grimlock/g' Dockerfile

docker build -t portnumber53/docker-phpfpm:${TAG} . \
  && docker push portnumber53/docker-phpfpm:${TAG} \
  && echo "Pushed image successfuly."
