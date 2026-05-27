#!/usr/bin/env zsh

load_gpg_agent() {
  gpg-connect-agent updatestartuptty /bye >/dev/null
}

load_gpg_agent
unfunction load_gpg_agent
