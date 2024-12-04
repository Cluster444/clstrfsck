#!/bin/bash

set -u

usage() {
	cat <<EOF
clstrfsck-init 0.1

The installer for clusterfsck development environment

Usage: cluck-init
EOF
}

main() {
	local -a pkgs
	pkgs=()

	has_tool curl || pkgs+=(curl)
	has_tool git  || pkgs+=(git)
	has_tool ruby || pkgs+=(ruby)

	if [ "${#pkgs[@]}" -gt 0 ]; then
		say "Installing ${pkgs[@]}"
		sudo apt install -qq -y "${pkgs[@]}"
	else
		say "All packages installed!"
	fi

	mkdir -p ~/.clstrfsck
	git clone --depth 1 https://github.com/Cluster444/clstrfsck ~/.clstrfsck
	cd ~/.clstrfsck

	exec bin/install
}

#### output helpers

if [[ -t 1 ]]
then
  tty_escape() { printf "\033[%sm" "$1"; }
else
  tty_escape() { :; }
fi
tty_mkbold() { tty_escape "1;$1"; }
tty_underline="$(tty_escape "4;39")"
tty_blue="$(tty_mkbold 34)"
tty_red="$(tty_mkbold 31)"
tty_bold="$(tty_mkbold 39)"
tty_reset="$(tty_escape 0)"

shell_join() {
  local arg
  printf "%s" "$1"
  shift
  for arg in "$@"
  do
    printf " "
    printf "%s" "${arg// /\ }"
  done
}

chomp() {
  printf "%s" "${1/"$'\n'"/}"
}

say() {
  printf "${tty_blue}==>${tty_bold} %s${tty_reset}\n" "$(shell_join "$@")"
}

has_tool() {
  [ -n $(type -P "$1") ]
}

main $@ || exit 1

