FROM oiprnd/oiptools:alpine-latest

ARG ACCOUNT_USERNAME
ARG ACCOUNT_PASSWORD

# User id to use when running container on OpenShift
ENV ACCOUNT_USERNAME=$ACCOUNT_USERNAME \
    ACCOUNT_PASSWORD=$ACCOUNT_PASSWORD \
    ACCOUNT_UID=1001 \
    ACCOUNT_GID=1001 \
    SSH_PORT=2222

EXPOSE $SSH_PORT

# Make sure we're executing as admin
USER root

# Install linux utility commands, used to log user activity
RUN info(){ printf '\n--\n%s\n--\n\n' "$*"; } \
 && info "==> installing openssh, tmux & script" \
 && apk add --no-cache util-linux tmux openssh openssh-server \
 && info "==> creating ssh host keys" \
 && ssh-keygen -A \
 && echo -e "ClientAliveInterval 1\nGatewayPorts yes\nPermitEmptyPasswords yes\nPort 8022\nClientAliveCountMax 10\nPermitRootLogin yes\n" >> /etc/ssh/sshd_config \
 && chmod -R g+r /etc/ssh \
 && info "==> disabling GSSAPIAuthentication authentication" \
 && sed -i "s/GSSAPIAuthentication yes/GSSAPIAuthentication no/" /etc/ssh/sshd_config \
 && info "==> cleaning up apk cache" \
 && rm -rf /var/cache/apk/* \
 && info "==> installing supervisord" \
 && pip2 install supervisor \
 && info "==> creating group 'csusers'..." \
 && addgroup -g $ACCOUNT_GID csusers \
 && info "==> allowing members of csusers group to use '/usr/bin/script'..." \
 && chgrp csusers /usr/bin/script \
 && chmod g+s /usr/bin/script \
 && info "==> creating user '$ACCOUNT_USERNAME'..." \
 && adduser -G csusers -u $ACCOUNT_UID -h /home/$ACCOUNT_USERNAME -s /usr/bin/bastion/shell -D $ACCOUNT_USERNAME
 #&& adduser -G csusers -u $ACCOUNT_UID -h /home/$ACCOUNT_USERNAME -s /usr/bin/bastion/shell -D $ACCOUNT_USERNAME \
 #&& info "==> setting $ACCOUNT_USERNAME password..." \
 #&& echo "$ACCOUNT_USERNAME:$ACCOUNT_PASSWORD" | chpasswd \
 #&& cat /etc/shadow


# Add various scripts in container image
ADD assets/ /

# Revert to non admin user
ENV HOME=/home/$ACCOUNT_USERNAME
USER $ACCOUNT_USERNAME

CMD ["/usr/bin/supervisord", "-n"]
