FROM oiprnd/oiptools:alpine-latest

ARG ACCOUNT_USERNAME
ARG ACCOUNT_PASSWORD

# User id to use when running container on OpenShift
ENV ACCOUNT_USERNAME=$ACCOUNT_USERNAME \
    ACCOUNT_PASSWORD=$ACCOUNT_PASSWORD \
    ACCOUNT_UID=1001 \
    SSH_PORT=2222

EXPOSE $SSH_PORT

# Make sure we're executing as admin
USER root

# Install linux utility commands, used to log user activity
RUN info(){ printf '\n--\n%s\n--\n\n' "$*"; } \
 && info "==> installing openssh, tmux & script" \
 && apk add --no-cache util-linux tmux openssh \
 && info "==> creating ssh host keys" \
 && ssh-keygen -A \
 && info "==> disabling GSSAPIAuthentication authentication" \
 && sed -i "s/GSSAPIAuthentication yes/GSSAPIAuthentication no/" /etc/ssh/sshd_config \
 && info "==> cleaning up apk cache" \
 && rm -rf /var/cache/apk/* \
 && info "==> installing supervisord" \
 && pip2 install supervisor

# Add various scripts in container image
ADD assets/ /

# Revert to non admin user
ENV HOME=/home/$ACCOUNT_USERNAME
USER $ACCOUNT_USERNAME

CMD ["/usr/bin/supervisord", "-n"]
