#!/bin/bash

if [ $(git st | grep -i 'nothing to commit.\+working directory clean' | wc -l) != 1 ] ; then
	echo -en $COLOR_LIGHT_RED
	echo '/*------------------------------------------------------------------'
	echo 'Erro: Arquivos alterados na working copy: ok (nenhum encontrado)'
	git st
	echo -en $COLOR_LIGHT_RED
	echo '------------------------------------------------------------------*/'
else
	echo -en $COLOR_GREEN
	echo 'Ok: Nenhum arquivo alterado na working copy'
fi

if [ $(git todo . | wc -l) != 0 ] ; then
	echo -en $COLOR_LIGHT_RED
	echo '/*------------------------------------------------------------------'
	echo 'Erro: faltam coisas importantes para remover no codigo (git todo .):'
	echo -en $COLOR_NONE
	git todo .
	echo -en $COLOR_LIGHT_RED
	echo '------------------------------------------------------------------*/'
else
	echo -en $COLOR_GREEN
	echo 'Ok: Nenhum arquivo com @todos importantes'
fi

V_CODE_SNIFFER_RESULTS=$(git no | xargs code-sniffer.sh -q)
if [ -n "$V_CODE_SNIFFER_RESULTS" ] ; then
	echo -en $COLOR_LIGHT_RED
	echo '/*------------------------------------------------------------------'
	echo 'Erro: Code Sniffer com coisas fora do padrao'
	echo -en $COLOR_NONE
	echo "$V_CODE_SNIFFER_RESULTS"
	echo -en $COLOR_LIGHT_RED
	echo '------------------------------------------------------------------*/'
else
	echo -en $COLOR_GREEN
	echo 'Ok: Nenhum problema nas linhas alteradas (Code Sniffer)'
fi

V_COMMIT_COUNT=$(git ls | grep '^commit ' | wc -l)
V_MESSAGE=
if [ $V_COMMIT_COUNT -gt 1 ] ; then
	V_MESSAGE='Erro: Mais de um commit; junte todos em um so antes de enviar ao SVN'
elif [ $V_COMMIT_COUNT = 1 ] ; then
	V_MESSAGE='Erro: existe um commit do Git que ainda nao foi enviado ao SVN'
else
	echo -en $COLOR_GREEN
	echo 'Ok: Nenhum commit pendente para enviar ao SVN (todos os commits do Git foram enviados)'
fi

if [ -n "$V_MESSAGE" ] ; then
	echo -en $COLOR_LIGHT_RED
	echo '/*------------------------------------------------------------------'
	echo $V_MESSAGE
	echo -en $COLOR_NONE
	git ls
	echo -en $COLOR_LIGHT_RED
	echo '------------------------------------------------------------------*/'
fi