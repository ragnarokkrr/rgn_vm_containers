#!/usr/bin/env bash
# docker help cp

sudo docker run --detach --name web nginx:latest
#ab20126535110c37c34abf80cacd84555146748a80cbb077224cac81cb904d69


docker run --interactive --tty --link web:web --name web_test busybox:latest /bin/sh


docker run --interactive --tty \ # keep stdin open with no terminal att and allocate virtual terminal for the container
--link web:web \ #link to nginx
--name web_test \ 
busybox:latest /bin/sh # run ssh inside container

#ctrl Q + ctrl P dettaches container


sudo docker run -it \
 --name agent \
 --link web:insideweb \
 --link mailer:insidemailer \
 dockerinaction/ch2_agent

