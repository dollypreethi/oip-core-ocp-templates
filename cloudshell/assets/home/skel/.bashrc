# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -f /usr/share/bash_completion/bash_completion ]; then
  source /usr/share/bash_completion/bash_completion
fi

# Basic logging function
_log() {
  echo $*
}

# Launching SSH agent
eval $(ssh-agent -s) > /dev/null 2>&1

load_private_keys() {
  for file in $(ls $HOME/.ssh/*); do
    if [ "$(head -1 $file)" == "-----BEGIN RSA PRIVATE KEY-----" ]; then
      _log "Loading SSH private key file '$file'"
      ssh-add $file
    fi
  done
}
