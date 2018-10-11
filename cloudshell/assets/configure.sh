#!/bin/sh
#

# Changing motd
cp /etc/motd /etc/motd.orig

cat <<-EOT > /etc/motd
Lab Open Innovation externe NEXT-IT.
-> Cloud Shell (Terminal-as-a-Service) offer
EOT

info() {
  printf '\n--\n%s\n--\n\n' "$*"
}

err() {
  echo $*
  exit 1
}

info "==> creating group 'csusers'..."
addgroup -g 1001 csusers

info "==> allowing members of csusers group to use '/usr/bin/script'..."
chgrp csusers /usr/bin/script
chmod g+s /usr/bin/script

# This part is specific to OpenShift/Kubernetes builds.
# A 'secret' will automatically be generated at deployment time and
# made available to this script using environment variables
[ -z "$ACCOUNT_USERNAME" ] && err "Variable 'ACCOUNT_USERNAME' should be defined!"
[ -z "$ACCOUNT_PASSWORD" ] && err "Variable 'ACCOUNT_USERNAME' should be defined!"

info "==> creating user '$ACCOUNT_USERNAME'..."
adduser -G csusers -h /home/$ACCOUNT_USERNAME -s /usr/bin/bastion/shell -D $ACCOUNT_USERNAME

info "==> setting $ACCOUNT_USERNAME password..."
echo "$ACCOUNT_USERNAME:$ACCOUNT_PASSWORD" | chpasswd
