#!/bin/bash
usage() {
	echo "Usage: $(basename $0) [options]
Conserta permissoes do Code Sniffer.

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
		exit 1
		;;
	esac
done

V_HOME_OFFICE_DIR="$HOME/Dropbox/src/home-office/dev_bin/devqa"
V_CODE_SNIFFER_DIR="$HOME/src/local/dev_bin/devqa"
V_FILES="$V_CODE_SNIFFER_DIR/*.sh $V_CODE_SNIFFER_DIR/pre-commit $V_HOME_OFFICE_DIR/*.sh $V_HOME_OFFICE_DIR/pre-commit"
chmod a+x $V_FILES
ls -l --color=auto $V_FILES

echo
echo 'Testando...'
code-sniffer.sh

echo 'Permissões do cliente ssh...'
chmod -v 600 $HOME/.ssh/* $HOME/Dropbox/linux/ssh*