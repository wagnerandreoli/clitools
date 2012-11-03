#!/bin/bash
usage() {
	echo "Usage: $(basename $0) [-epah] [-s segundos]
Abre os clientes de linha de comando com bancos MySQL e Mongo.

  -e   Edita o arquivo de conexoes
  -p   Mostra todos os processos do MySQL (SHOW FULL PROCESSLIST)
  -a   Mostra todos os processos ATIVOS do MySQL (SHOW FULL PROCESSLIST, exceto Sleep)
  -s   Segundos para SHOW FULL PROCESSLIST
  -h   Ajuda"
	exit $1
}

V_FILE=$HOME/Dropbox/Docs/connections.txt
if [ ! -f "$V_FILE" ] ; then
	echo "Arquivo com as conexoes nao foi encontrado: $V_FILE"
	exit
fi

V_PROCESSLIST=
V_ACTIVE=
V_SECONDS=2
while getopts "epas:h" OPTION ; do
	case $OPTION in
	e)
		subl $V_FILE &
		exit
		;;
	p)
		V_PROCESSLIST=1
		;;
	a)
		V_PROCESSLIST=1
		V_ACTIVE=1
		;;
	s)
		V_SECONDS=$OPTARG
		;;
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

V_CHOSEN=$(cat -s "$V_FILE" | grep -v -e '^$' -e '^#' -e '^\/\/' | zenity --width=1000 --height=500 --text "Escolha uma conexao para abrir:" --list --column 'Banco' --column 'Comando' --print-column=ALL)
[ -z "$V_CHOSEN" ] && exit

V_OLD_IFS=$IFS
IFS='|'
V_NAME=
V_COMMAND=
for V_PIECE in $V_CHOSEN ; do
	if [ -z "$V_NAME" ] ; then
		V_NAME="$V_PIECE"
	else
		V_COMMAND="$V_PIECE"
	fi
done
IFS=$V_OLD_IFS

V_IS_MYSQL=$(echo $V_COMMAND | grep -o mysql)
if [ -n "$V_PROCESSLIST" ] && [ -n "$V_IS_MYSQL" ] ; then
	if [ -n "$V_ACTIVE" ] ; then
		V_COMMAND="watch -n $V_SECONDS -d '$V_COMMAND -e\"show full processlist\" | grep -v -e Sleep -e \"show full processlist\" '"
	else
		V_COMMAND="watch -n $V_SECONDS -d '$V_COMMAND -e\"show full processlist\"'"
	fi
fi

printf '\033]2;%s\007' "$V_NAME / $V_COMMAND"

function connection_id() {
	echo '------------------------------------------------------------------'
	echo "Nome da conexao: $V_NAME"
	echo "Comando executado: $V_COMMAND"
	echo '------------------------------------------------------------------'
}

connection_id
eval $V_COMMAND
connection_id