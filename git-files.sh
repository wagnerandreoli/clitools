#!/bin/bash
usage() {
	echo "Usage: $(basename $0) [-h]
Mostra os arquivos de um commit

  -h   Ajuda"
	exit $1
}

while getopts "h" OPTION ; do
	case $OPTION in
	h)
		usage
		exit 1
		;;
	?)
		usage
		exit
		;;
	esac
done

V_COMMIT=$1
git show $V_COMMIT --name-only --pretty="format:" | tail -n+2
