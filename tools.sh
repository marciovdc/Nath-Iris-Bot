#!/usr/bin/env bash

######################################################################################
#
#	MIT License
#
#	Copyright (c) 2021 KillovSky - Lucas R.
#
#	Permission is hereby granted, free of charge, to any person obtaining a copy
#	of this software and associated documentation files (the "Software"), to deal
#	in the Software without restriction, including without limitation the rights
#	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#	copies of the Software, and to permit persons to whom the Software is
#	furnished to do so, subject to the following conditions:
#
#	The above copyright notice and this permission notice shall be included in all
#	copies or substantial portions of the Software.
#
#	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#	SOFTWARE.
#
######################################################################################

######	######	######	######	######	######	######	######	######	######	#
#	 Construído por KillovSky para utilização no Projeto Nath-Íris					#
#	   Página oficial -> https://github.com/KillovSky/Iris						#
#	 Como faz parte do programa Nath-Íris, isso utiliza a licença MIT também			#
# 				Não remova os créditos e divirta-se!							#
######	######	######	######	######	######	######	######	######	######	#

# Opções de inicialização
message="[NATH-NATH-ÍRIS] → Funções suportadas por mim:\n\nParar a Nath-Íris = 1\n-> (Apenas se usou o 3)\n\nNormal Start = 2\n-> (Inicia normalmente) \n\nTXT Background Start = 3\n-> (Roda de fundo SEM ANTI CRASH e envia os logs para o 'BG_Start.log', não recomendado [EXPERTS]!)\n\nPM2 Background Start = 4\n-> (PM2 Anti Crash, roda de fundo, auto-reboot a cada 6 horas)\n\nPM2 Start = 5\n-> (PM2 Anti Crash, exibe na tela, auto-reboot a cada 6 horas)\n\nParar o PM2 = 6\n-> (Apenas se usou o 4 ou 5)\n\nAnti-Crash Sem PM2 = 7\n-> (Anti Crash sem PM2)\n\nIncialização customizada = 8\n-> (Digite o comando de inicialização)\n\nAtualizar os módulos = 9\n-> (Faz a atualização da 'node_modules' da Nath-Íris)\n\nInstalar os módulos = 10\n-> (Faz a instalação dos módulos, essencial na primeira vez)\n\nLimpar a Nath-Íris = 11\n-> (Limpa a Nath-Íris - incluso Backups, mantém o mais recente)\n\nDeletar sessão do WhatsApp Web = 12\n-> (Desconecta do WhatsApp Web)\n\nAtualizar/Reinstalar a Nath-Íris = 13\n-> (Refaz os passos de instalação)\n\nConfigurar os JSON's = 14\n-> (Configure as API's sem abrir os arquivos)\n\nInstalar PM2 = 15\n-> (Instala o PM2 no PC)\n\nSair = 16\n-> (Sai do Toolkit)\n\n"

# Checa se o local já é a pasta da Nath-Íris
isCorrect=$(ls | egrep -w "lib|package.json|start.js")
if [[ "$isCorrect" == *"start.js"* && "$isCorrect" == *"lib"* && "$isCorrect" == *"package.json"* ]]; then

	# Script que faz a execução/outros da Nath-Íris
	array=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16")
	while : ; do
		if [ "$#" -eq 0 ] ; then
			printf "\n${message}"
			break
		else
			if [[ "${array[@]}" =~ "$1" ]] ; then
				case "$1" in

					# Cancela a execução do script caso a pessoa rode o modo hide.
					"1")
						printf "\n[NATH-ÍRIS | DONE] → Função executada, output (se existir) -> "
						kill $(ps | grep node | awk '{print $1}')
						exit
					;;

					# Executa normalmente, mostrando os reinícios, logs e mensagens.
					"2")
						if [ -d "node_modules" ]; then
							printf "\n[NATH-ÍRIS] → Função iniciada, output do NPM -> \n"
							npm start
							exit
						else
							printf "[NATH-ÍRIS] → Você não fez a instalação, deseja instalar os módulos?\n\n"
							select opt in "Instalar" "Cancelar"; do
								case $opt in
									"Instalar")
										bash tools.sh 15
										sleep 60
										npm start
										exit
									;;
									"Cancelar")
										printf "[NATH-ÍRIS] → Foi um prazer, volte sempre!\n"
										exit
									;;
								esac
							done
						fi
						exit
					;;

					# Modo Hide, inicia mas envia os logs para o arquivo BG_Start.log.
					"3")
						if [ -d "node_modules" ]; then
							printf "\n[NATH-ÍRIS] → Função iniciada, output (se existir, deve cair no 'BG_Start.log') -> "
							npm start &>BG_Start.log &
							exit
						else
							printf "[NATH-ÍRIS] → Você não fez a instalação, deseja instalar os módulos?\n\n"
							select opt in "Instalar" "Cancelar"; do
								case $opt in
									"Instalar")
										bash tools.sh 15
										sleep 60
										npm start &>BG_Start.log &
										exit
									;;
									"Cancelar")
										printf "[NATH-ÍRIS] → Foi um prazer, volte sempre!\n"
										exit
									;;
								esac
							done
						fi
						exit
					;;

					# Executa em pm2 de fundo.
					"4")
						if ! [ -x "$(command -v pm2)" ]; then
							select opt in "Instalar PM2" "Sair"; do
								case $opt in
									"Instalar PM2")
										bash tools.sh 15
										sleep 60
										exit
									;;
									"Sair")
										printf "[NATH-ÍRIS] → Foi um prazer, volte sempre!\n"
										exit
									;;
								esac
							done
						fi
						printf "\n[NATH-ÍRIS] → Função executada, output (se existir) -> "
						pm2 start start.js --name iris --cron-restart="0 */6 * * *"
						exit
					;;

					# Executa em pm2, mostrando os reinícios, logs e mensagens.
					"5")
						if ! [ -x "$(command -v pm2)" ]; then
							select opt in "Instalar PM2" "Sair"; do
								case $opt in
									"Instalar PM2")
										bash tools.sh 15
										sleep 60
										exit
									;;
									"Sair")
										printf "[NATH-ÍRIS] → Foi um prazer, volte sempre!\n"
										exit
									;;
								esac
							done
						fi
						printf "\n[NATH-ÍRIS] → Função executada, output (se existir) -> "
						pm2 start start.js --name iris --cron-restart="0 */6 * * *"
						sleep 10
						pm2 monit
						exit
					;;

					# Desliga a Nath-Íris desligando o PM2.
					"6")
						if ! [ -x "$(command -v pm2)" ]; then
							select opt in "Instalar PM2" "Sair"; do
								case $opt in
									"Instalar PM2")
										bash tools.sh 15
										sleep 60
										exit
									;;
									"Sair")
										printf "[NATH-ÍRIS] → Foi um prazer, volte sempre!\n"
										exit
									;;
								esac
							done
						fi
						printf "\n[NATH-ÍRIS] → Função executada, output (se existir) -> "
						pm2 kill
						exit
					;;

					# Executa o método de execução feito por Gabriel Dias, a diferença é que não se usa PM2.
					# Todos os créditos disso a ele -> https://github.com/gabrieldiaspereira | https://github.com/KillovSky/iris/pull/531
					"7")
						if ! [ -x "$(command -v pm2)" ]; then
							select opt in "Instalar PM2" "Sair"; do
								case $opt in
									"Instalar PM2")
										bash tools.sh 15
										sleep 60
										exit
									;;
									"Sair")
										printf "[NATH-ÍRIS] → Foi um prazer, volte sempre!\n"
										exit
									;;
								esac
							done
						fi
						printf "\n[NATH-ÍRIS] → Função executada, output (se existir) -> "
						while : ; do
							printf "[NATH-ÍRIS] → $('\033[0;32m') Iniciando Nath-Íris, caso o processo sofra falhas, um reinicio automático será feito.\n"
							npm start
							sleep 1
						done
						exit
					;;

					# Executa um método customizado ou qualquer coisa jogada aqui
					"8")
						read customMode
						printf "\n[NATH-ÍRIS] → Função iniciada, output (se existir) -> "
						$customMode
						exit
					;;

					# Atualiza os módulos
					"9")
						if [ -d "node_modules" ]; then
							printf "\n[NATH-ÍRIS] → Função iniciada, output do NPM -> \n"
							npm update
						else
							printf "[NATH-ÍRIS] → Você não fez a instalação, deseja instalar os módulos?\n\n"
							select npi in "Sim" "Não"; do
								case $npi in
									"Sim")
										bash tools.sh 10
										exit
									;;
									"Não")
										printf "[NATH-ÍRIS | DONE] → Ok, obrigado por utilizar este programa! <3"
										exit
									;;
								esac
							done
						fi
						exit
					;;

					# Faz a instalação dos módulos
					"10")
						if [ -d "node_modules" ]; then
							printf "[NATH-ÍRIS] → Os módulos já existem, deseja tentar atualizar?\n\n"
							select upx in "Sim" "Não"; do
								case $upx in
									"Sim")
										bash tools.sh 9
										sleep 60
										exit
									;;
									"Sair")
										printf "[NATH-ÍRIS | DONE] → Foi um prazer, volte sempre!\n"
										exit
									;;
								esac
							done
						fi
						if ! [ -x "$(command -v pm2)" ]; then
							select opt in "Instalar PM2" "Sair"; do
								case $opt in
									"Instalar PM2")
										bash tools.sh 15
										sleep 60
										exit
									;;
									"Sair")
										printf "[NATH-ÍRIS | DONE] → Foi um prazer, volte sempre!\n"
										exit
									;;
								esac
							done
						fi
						printf "\n[DONE] - Todas as funções requisitadas foram executadas!"
						exit
					;;

					# Limpa a Nath-Íris, não apaga a sessão se não for MD
					"11")
						isMultiple=$(grep 'Multi_Devices' ./lib/config/Settings/session.json | sed 's/.*\": //g' | sed 's/,$//g')
						lastBackup=$(ls -t ./lib/config/Backups | head -n 1)
						backupsLength=$(ls ./lib/config/Backups | wc -l)
						if [[ ! -z "$lastBackup" && backupsLength -gt 1 ]];then
							echo "Limpando a pasta de backups..."
							mv "./lib/config/Backups/${lastBackup}" "./lib/config/Backups/Latest_Backup.zip"
							rm ./lib/config/Backups/[0-9]*
						fi
						if [ "$isMultiple" == "false" ]; then
							rm -r lib/session/*/
						else
							echo "Usando Multi_Devices, ignorando limpeza do Chrome..."
						fi
						rm -rf package-lock.json
						printf "\n[DONE] - Limpeza concluída!"
						exit
					;;

					# Apaga a sessão da Nath-Íris
					"12")
						if [[ -d "lib/session" ]]; then
							rm -rf lib/session
							echo "\n[DONE] - Sessão do WhatsApp Web desconectada!"
						else
							printf "\n[NATH-ÍRIS | DONE] → Você ainda não possui uma sessão conectada."
						fi
						exit
					;;

					# Atualiza/Reinstala a Nath-Íris - Não use se tiver feito edições
					"13")
						latestVersion=$(curl https://raw.githubusercontent.com/KillovSky/iris/main/package.json | grep "version" | sed 's/.*": "//g' | sed 's/\",//g')
						hisVersion=$(cat package.json | grep "version" | sed 's/.*": "//g' | sed 's/\",//g')
						if [[ "$latestVersion" == "$hisVersion" ]]; then
							printf "\n[NATH-ÍRIS] → Esta versão já é a mesma versão que você está usando, deseja continuar?\n\n"
						else
							printf "\n[NATH-ÍRIS] → Existe uma atualização disponível para você, deseja continuar?\n\n"
						fi
						select for in "Sim" "Não"; do
							case $for in
								"Sim")
									randName=$(echo $RANDOM | base64 | head -c 20; echo)
									dateNow=$(date -I)
									folderName="Backup-#-${randName}-#-${dateNow}"
									files=$(ls -At | egrep -v 'tools|${randName}|Tutorial')
									printf "\n[NATH-ÍRIS] → 1 - Essa função criará um backup das pastas (Oficiais) da Nath-Íris antes de atualizar.\n\n2 - Se caso uma das pastas (Oficiais) não seja inserida no Backup, seu conteúdo será substituído automaticamente.\n\n3 - A atualização NÃO SALVARÁ as edições feitas no programa.\n\n4 - Você poderá inserir as edições manualmente acessando os arquivos do Backup.\n\nArquivos que serão movidos para a pasta de Backup =\n\n${files}\n\nDeseja continuar?\n\n"
									select opt in "Fazer a atualização" "Cancelar atualização" "Apenas baixar o ZIP"; do
										case $opt in
											"Fazer a atualização")
												curl -LO -# https://github.com/KillovSky/iris/archive/refs/heads/main.zip
												if [[ -f "main.zip" ]]; then
													unzip -qo main.zip
													MDEnabled=$(grep 'Multi_Devices' './lib/config/Settings/session.json' | sed 's/.*\": //g' | sed 's/,$//g')
													if [ -d "$folderName" ] ; then
														folderName="${folderName}"/"${folderName}"
													fi
													rm -rf Tutorial\ de\ Edição\ PT-BR.txt
													mkdir "${folderName}"
													mv $files "${folderName}"
													sleep 5
													rm iris-main/tools.sh iris-main/tools.py
													mv iris-main/* .
													mv iris-main main.zip "${folderName}"
													mv "${folderName}/node_modules" .
													printf "\n[NATH-ÍRIS] → Extração e Backup executados, indo para próxima etapa...\n"
													#sleep 10 # , limpando o terminal em 10 segundos...
													#clear
													printf "\n[NATH-ÍRIS] → Deseja fazer a auto-configuração dos arquivos da pasta 'Settings' usando os antigos arquivos?\n\nValores que não existem na versão baixada da Nath-Íris serão ignorados.\n\nEsta opção vai configurar as API's e demais configurações automaticamente para você, desde que você tenha configurado anteriormente, antes da atualização.\n\n"
													select md in "Aplicar valores antigos" "Não aplicar valores"; do
														case $md in
															"Aplicar valores antigos")
																printf "\n[NATH-ÍRIS] → Essa função será executada pelo NodeJS, avisarei quando terminar.\n\n"
																node lib/functions/shell_extra.js "./${folderName}/lib/config/Settings/config.json" "./lib/config/Settings/config.json"
																node lib/functions/shell_extra.js "./${folderName}/lib/config/Settings/APIS.json" "./lib/config/Settings/APIS.json"
																node lib/functions/shell_extra.js "./${folderName}/lib/config/Gerais/functions.json" "./lib/config/Gerais/functions.json"
																node lib/functions/shell_extra.js "./${folderName}/lib/config/Settings/session.json" "./lib/config/Settings/session.json"
																node lib/functions/shell_extra.js "./${folderName}/lib/config/Settings/commands.json" "./lib/config/Settings/commands.json"
																node lib/functions/shell_extra.js "./${folderName}/lib/config/Settings/chrome.json" "./lib/config/Settings/chrome.json"
																printf "\n[NATH-ÍRIS] → \nTerminado, suas configurações foram importadas.\n"
																break
															;;
															"Não aplicar valores")
																printf "\n[NATH-ÍRIS] → Okay, irei pular a configuração dos arquivos.\n"
																break
															;;
														esac
													done
													printf "\n[NATH-ÍRIS] → Deseja instalar/atualizar os módulos e iniciar a Nath-Íris?\n\n"
													select up in "Sim" "Não" "Apenas atualizar/instalar" "Apenas iniciar"; do
														case $up in
															"Sim")
																printf "\n${message}[NATH-ÍRIS] → Qual opção acima (número) você deseja usar para inciar a Nath-Íris após atualizar?\n"
																read whatOption
																if [ -d "node_modules" ] ; then
																	npm update
																else
																	npm i
																fi
																printf "\n[NATH-ÍRIS] → A atualização/instalação terminou, irei ligar em 10 segundos.\n"
																sleep 10
																bash tools.sh $whatOption
																exit
															;;
															"Não")
																printf "\n[NATH-ÍRIS] → Entendido, obrigado por utilizar o menu de opções!\n"
																exit
															;;
															"Apenas atualizar/instalar")
																if [ -d "node_modules" ] ; then
																	npm update
																else
																	npm i
																fi
																printf "\n[NATH-ÍRIS] → A atualização/instalação terminou, obrigado por utilizar o sistema de opções!\n"
																exit
															;;
															"Apenas iniciar")
																if [ -d "node_modules" ] ; then
																	printf "\n${message}[NATH-ÍRIS] → Qual opção acima (número) você deseja usar para inciar a Nath-Íris após atualizar?\nEscolha -> "
																	read whatOption
																	bash tools.sh $whatOption
																	exit
																else
																	printf "\nVocê não possui os módulos, deseja instalar?"
																	select dims in "Sim" "Não"; do
																		case $dims in
																			"Sim")
																				bash tools.sh 10
																				exit
																			;;
																			"Não")
																				printf "[NATH-ÍRIS] → Ok, obrigado por utilizar este programa! <3"
																				exit
																			;;
																		esac
																	done
																fi
															;;
														esac
													done
													exit
												else
													printf "\n[NATH-ÍRIS] → Algum erro aconteceu durante o download da atualização.\n"
													exit
												fi
											;;
											"Cancelar atualização")
												printf "[NATH-ÍRIS] → Você cancelou a atualização da Nath-Íris.\n"
												exit
											;;
											"Apenas baixar o ZIP")
												curl -LO -# https://github.com/KillovSky/iris/archive/refs/heads/main.zip
												if test -f "main.zip"; then
													printf "[NATH-ÍRIS] → A atualização foi baixada com sucesso, você pode abrir clicando no arquivo 'main.zip'.\n"
													exit
												else
													printf "[NATH-ÍRIS] → Houve algum erro durante o download da atualização.\n"
													exit
												fi
										esac
									done
								;;
								"Não")
									printf "[NATH-ÍRIS] → Você decidiu cancelar a atualização, se quiser algo mais, basta rodar novamente."
									exit
								;;
							esac
						done
					;;

					# Configura um dos JSON's
					"14")
						if [ -d "lib" ] ; then
							printf "[NATH-ÍRIS] → Essa função será executada pela 'Python', portanto, evite acentos e emojis, pois, isso pode causar erros de 'unicode'.\nQual arquivo JSON deseja editar?\n\n"
							select npu in "APIS" "Config" "Outro"; do
								case $npu in
									"APIS")
										if [[ -f "lib/config/Settings/APIS.json" ]]; then
											python tools.py 1
											exit
										else
											printf "[NATH-ÍRIS] → O arquivo 'APIS.json' não existe, faça uma reinstalação."
										fi
									;;
									"Config")
										if [[ -f "lib/config/Settings/config.json" ]]; then
											python tools.py 2
											exit
										else
											printf "[NATH-ÍRIS] → O arquivo 'config.json' não existe, faça uma reinstalação."
										fi
									;;
									"Outro")
										printf "[NATH-ÍRIS] → Escreva o local do arquivo, junto com o '.json' no fim, sem espaços.\n\nPor exemplo -> './lib/config/Settings/session.json'\n\nO local que desejo usar é: "
										read CustomFile
										if [[ -f "${CustomFile}" ]]; then
											python tools.py 3 "${CustomFile}"
											exit
										else
											printf "[NATH-ÍRIS] → O arquivo ${customFile} não existe, faça uma reinstalação."
										fi
									;;
								esac
							done
						else
							printf "[NATH-ÍRIS] → Como diabos você chegou nessa resposta?\nIsso normalmente é super raro!\nDe toda forma, você não possui a Nath-Íris instalada, faça o 'Git Clone'."
							exit
						fi
					;;

					# Instala o PM2
					"15")
						printf "\n[NATH-ÍRIS] → Função iniciada, output (se existir) -> "
						npm i pm2 -g
						exit
					;;

					# Sai da Toolbox
					"16")
						printf "[NATH-ÍRIS] → Foi um prazer, volte sempre!\n"
						exit
					;;

					# Caso não seja digitado uma opção válida
					*)
						printf "${message}[NATH-ÍRIS] → Execute corretamente digitando uma opção da lista acima!\n"
						exit
					;;

				# Finalização
				esac
			else
				printf "${message}[NATH-ÍRIS] → Execute corretamente digitando uma opção da lista acima!\n"
				exit
			fi
		fi
	done

	# Caso a pessoa abra direto, não usando um terminal
	printf "[NATH-ÍRIS] → Na próxima, abra o terminal e execute o comando: 'bash tools.sh <opção>'\nExemplo: 'bash tools.sh 1'\n\n[NATH-ÍRIS] → Digite o número da opção que deseja utilizar, acima estão as descrições.\n\n"
	# COLUMNS=10 # Ative se ficar muito estranho o menu de opções
	functions=("Opção 1 - Stop BG" "Opção 2 - Normal Start" "Opção 3 - BG Start" "Opção 4 - PM2 Start | Sem Monitor" "Opção 5 - PM2 Start | Com Monitor" "Opção 6 - Stop PM2" "Opção 7 - Anti-Crash | Sem PM2" "Opção 8 - Custom Start" "Opção 9 - Atualizar módulos" "Opção 10 - Instalar módulos" "Opção 11 - Limpar a Nath-Íris" "Opção 12 - Sair do WhatsApp Web" "Opção 13 - Atualizar/Reinstalar" "Opção 14 - Configurar os JSON's" "Opção 15 - Instalar PM2" "Opção 16 - Sair")
	select op in "${functions[@]}"; do
		printf "\n[NATH-ÍRIS] → O script será fechado em 60 segundos após a execução, caso queira fechar antes, aperte 'CTRL + C', mas, NÃO FECHE DURANTE A EXECUÇÃO DE OPÇÕES!\n\n[NATH-ÍRIS] → Lembre-se, na próxima, use o comando: 'bash tools.sh <opção>'\n"
		printf "\n[NATH-ÍRIS] → Aguarde, carregando script em 5 segundos...\n\n"
		sleep 5
		case $op in
			"Opção 1 - Stop BG")
				bash tools.sh 1
				sleep 60
				exit
			;;
			"Opção 2 - Normal Start")
				bash tools.sh 2
				sleep 60
				exit
			;;
			"Opção 3 - BG Start")
				bash tools.sh 3
				sleep 60
				exit
			;;
			"Opção 4 - PM2 Start | Sem Monitor")
				bash tools.sh 4
				sleep 60
				exit
			;;
			"Opção 5 - PM2 Start | Com Monitor")
				bash tools.sh 5
				sleep 60
				exit
			;;
			"Opção 6 - Stop PM2")
				bash tools.sh 6
				sleep 60
				exit
			;;
			"Opção 7 - Anti-Crash | Sem PM2")
				bash tools.sh 7
				sleep 60
				exit
			;;
			"Opção 8 - Custom Start")
				bash tools.sh 8
				sleep 60
				exit
			;;
			"Opção 9 - Atualizar módulos")
				bash tools.sh 9
				sleep 60
				exit
			;;
			"Opção 10 - Instalar módulos")
				bash tools.sh 10
				sleep 60
				exit
			;;
			"Opção 11 - Limpar a Nath-Íris")
				bash tools.sh 11
				sleep 60
				exit
			;;
			"Opção 12 - Sair do WhatsApp Web")
				bash tools.sh 12
				sleep 60
				exit
			;;
			"Opção 13 - Atualizar/Reinstalar")
				bash tools.sh 13
				sleep 60
				exit
			;;
			"Opção 14 - Configurar os JSON's")
				bash tools.sh 14
				sleep 60
				exit
			;;
			"Opção 15 - Instalar PM2")
				bash tools.sh 15
				sleep 60
				exit
			;;
			"Opção 16 - Sair")
				printf "[NATH-ÍRIS] → Foi um prazer, volte sempre!\n"
				exit
			;;
		esac
	done
else
	if [ -d "iris" ]; then
		isEmpty=$(ls -a iris | egrep -w "lib|package.json|start.js" | wc -l)
		if [[ $isEmpty < 3 ]]; then
			mv iris irisCorrupt
			bash tools.sh
		else
			cp tools.sh iris
			cd iris
			bash tools.sh
		fi
	fi
	printf "[NATH-ÍRIS] → Este script apenas pode ser executado em uma pasta de instalação da Nath-Íris, faça o git clone e utilize corretamente.\n\nDeseja fazer o git clone ou cancelar o uso?\n\n"
	select cl in "Fazer o Git Clone" "Sair"; do
		case $cl in
			"Fazer o Git Clone")
				printf "[NATH-ÍRIS] → Verificando se você possui os programas necessários para isso...\n\n"
				if ! [ -x "$(command -v git)" ]; then
					printf '[NATH-ÍRIS] → Você não possui GIT instalado, deseja instalar GIT agora?\n\n'
					case "$(uname -s)" in
						Linux*)
							select ist in "Sim" "Não/Sair"; do
								case $ist in
									"Sim")
										printf "[NATH-ÍRIS] → Pode ser que você precise fornecer a senha para instalar, não se preocupe, isso é um procedimento seguro, não irei armazenar ou fazer quaisquer coisas com sua senha, eu respeito a segurança.\n\n"
										if ! [ -x "$(command -v sudo)" ]; then
											if ! [ -x "$(command -v apt)" ]; then
												printf "[NATH-ÍRIS] → Você não possui o APT no sistema, isso pode ser muito complicado para este script, peço que procure tutoriais para compilação do APT, ou, instale os programas que a Nath-Íris precisa, manualmente."
												exit
											else
												apt install git -y 
											fi
										else
											sudo apt install git -y
										fi
										if ! [ -x "$(command -v git)" ]; then
											printf "[NATH-ÍRIS] → Alguma coisa deu errada ao instalar o GIT, faça uma verificação manual e tente rodar o script depois."
											exit
										else
											printf "[NATH-ÍRIS] → Prontinho, instalação do GIT foi um sucesso!\n\n"
											break
										fi
									;;
									"Não/Sair")
										printf "[NATH-ÍRIS] → Entendido, até a próxima! <3"
										exit
									;;
								esac
							done
						;;
						Darwin*)
							if ! [ -x "$(command -v brew)" ]; then
								if ! [ -x "$(command -v port)" ]; then
									printf "[NATH-ÍRIS] → Você não possui 'brew' ou 'port' no sistema, isso pode ser muito complicado para este script, peço que procure tutoriais para compilação deles, ou, instale os programas que a Nath-Íris precisa, manualmente."
									exit
								else
									printf "[NATH-ÍRIS] → Pode ser que você precise fornecer a senha para instalar, não se preocupe, isso é um procedimento seguro, não irei armazenar ou fazer quaisquer coisas com sua senha, eu respeito a segurança.\n\n"
									if ! [ -x "$(command -v sudo)" ]; then
										port selfupdate
										port install git +svn +doc +bash_completion +gitweb 
									else
										sudo port selfupdate
										sudo port install git +svn +doc +bash_completion +gitweb
									fi
								fi
							else
								brew install git 
							fi
							if ! [ -x "$(command -v git)" ]; then
								printf "[NATH-ÍRIS] → Alguma coisa deu errada ao instalar o GIT, faça uma verificação manual e tente rodar o script depois."
								exit
							else
								printf "[NATH-ÍRIS] → Prontinho, instalação do APT foi um sucesso!\n\n"
								break
							fi
						;;
						*)
							printf '[NATH-ÍRIS] → Você não possui GIT instalado, instale acessando "https://git-scm.com/downloads".\nVocê deve fazer o download da versão $(uname -m).'
							exit
						;;
					esac
				fi
				case "$(uname -s)" in
					Linux*)
						needUpdate=0
						if [[ -x "$(command -v node)" && -x "$(command -v npm)" ]]; then
							isLTS=$(node -v | sed 's/v//g' | sed 's/\.//g')
							isNLTS=$(npm -v | sed 's/v//g' | sed 's/\.//g')
							if [[ $isLTS < 16140 || $isNLTS < 814 ]]; then
								printf "[NATH-ÍRIS] → Sua versão do NodeJS/NPM é considerada muito antiga, deseja utilizar o node-source para atualizar para a versão LTS?\n\n"
								needUpdate=1
							else
								printf "[NATH-ÍRIS] → Você possui a versão mais atualizada do NodeJS e NPM, parabéns!\n\n"
							fi
						elif ! [[ -x "$(command -v node)" && -x "$(command -v npm)" ]]; then
							printf "[NATH-ÍRIS] → Você não possui NodeJS e NPM, deseja instalar?\n\n"
							needUpdate=1
						else
							printf "[NATH-ÍRIS] → Eu não sei o que aconteceu, mas, por via das dúvidas, irei parar por aqui, seu sistema diz que tem e também diz que não tem o nodejs e npm...como isso é possível...?\n\n"
							exit
						fi
						if [[ "$needUpdate" == 1 ]]; then
							select nd in "Sim" "Não/Sair"; do
								case $nd in
									"Não/Sair")
										printf "[NATH-ÍRIS] → Okay, espero que você volte um dia, até a próxima!"
										exit
									;;
									"Sim")
										if ! [[ -x "$(command -v sudo)" && -x "$(command -v apt)" ]]; then
											printf "[NATH-ÍRIS] → Você não possui o APT no sistema, isso pode ser muito complicado para este script, peço que procure tutoriais para compilação do APT, ou, instale os programas que a Nath-Íris precisa, manualmente."
											exit
										fi
										printf "[NATH-ÍRIS] → Pode ser que você precise fornecer a senha para instalar, não se preocupe, isso é um procedimento seguro, não irei armazenar ou fazer quaisquer coisas com sua senha, eu respeito a segurança.\n\n"
										if ! [ -x "$(command -v sudo)" ]; then
											curl -fsSL https://deb.nodesource.com/setup_lts.x | bash
										else
											curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo bash
										fi
										isLTS=$(apt show nodejs | grep Version | sed 's/.*: //g' | sed 's/\.//g')
										if (( $isLTS < 16140 )); then
											printf "[NATH-ÍRIS] → Sua versão do NodeJS no APT continua inferior a versão necessária, faça uma verificação manualmente.\n\n"
											exit
										else
											if ! [ -x "$(command -v sudo)" ]; then
												apt-get install -y nodejs
											else
												sudo apt-get install -y nodejs
											fi
										fi
										if ! [[ -x "$(command -v node)" && -x "$(command -v npm)" ]]; then
											printf "[NATH-ÍRIS] → Você ainda não possui NodeJS e NPM, alguma coisa ocorreu na instalação, verifique manualmente.\n\n"
											exit
										else
											printf "[NATH-ÍRIS] → A instalação do NodeJS e NPM foi um sucesso, passarei para a próxima etapa.\n\n"
											break
										fi
									;;
								esac
							done
						fi
					;;
					Darwin*)
						if ! [[ -x "$(command -v node)" && -x "$(command -v npm)" ]]; then
							printf "\n[NATH-ÍRIS] → Você não possui NodeJS e NPM, deseja instalar?\n\n"
							select nd in "Sim" "Não/Sair"; do
								case $nd in
									"Não/Sair")
										printf "[NATH-ÍRIS] → Okay, espero que você volte um dia, até a próxima!"
										exit
									;;
									"Sim")
										if ! [ -x "$(command -v brew)" ]; then
											if ! [ -x "$(command -v port)" ]; then
												printf "[NATH-ÍRIS] → Você não possui 'brew' ou 'port' no sistema, isso pode ser muito complicado para este script, peço que procure tutoriais para compilação deles, ou, instale os programas que a Nath-Íris precisa, manualmente."
												exit
											else
												printf "[NATH-ÍRIS] → Pode ser que você precise fornecer a senha para instalar, não se preocupe, isso é um procedimento seguro, não irei armazenar ou fazer quaisquer coisas com sua senha, eu respeito a segurança.\n\n"
												if ! [ -x "$(command -v sudo)" ]; then
													port selfupdate
													port install nodejs npm
												else
													sudo port selfupdate
													sudo port install nodejs npm
												fi
											fi
										else
											brew install node
										fi
										if ! [[ -x "$(command -v node)" && -x "$(command -v npm)" ]]; then
											printf "[NATH-ÍRIS] → Você ainda não possui NodeJS e NPM, alguma coisa ocorreu na instalação, verifique manualmente."
											exit
										else
											printf "[NATH-ÍRIS] → A instalação do NodeJS e NPM foi um sucesso, passarei para a próxima etapa.\n\n"
											break
										fi
									;;
								esac
							done
						fi
					;;
					*)
						if [[ -x "$(command -v node)" && -x "$(command -v npm)" ]]; then
							isLTS=$(node -v | sed 's/v//g' | sed 's/\.//g')
							isNLTS=$(npm -v | sed 's/v//g' | sed 's/\.//g')
							if [[ $isLTS < 16140 || $isNLTS < 814 ]]; then
								printf "[NATH-ÍRIS] → Sua versão do NodeJS/NPM é considerada muito antiga, faça a instalação do NodeJS e NPM [LTS] -> https://nodejs.org/en"
								exit
							else
								printf "[NATH-ÍRIS] → Você possui a versão mais atualizada do NodeJS e NPM, parabéns!\n\n"
							fi
						elif ! [[ -x "$(command -v node)" && -x "$(command -v npm)" ]]; then
							printf "[NATH-ÍRIS] → Instale NodeJS e NPM [LTS] para prosseguir, você pode obter eles pela página -> https://nodejs.org/en"
							exit
						else
							printf "[NATH-ÍRIS] → Eu não sei o que aconteceu, mas, por via das dúvidas, irei parar por aqui, seu sistema diz que tem e também diz que não tem o nodejs e npm...como isso é possível...?"
							exit
						fi
					;;
				esac
				printf "[NATH-ÍRIS] → Deseja utilizar a versão DEV ou a versão MAIN?\n\n[NATH-ÍRIS] → A versão DEV possui mais comandos, estabilidade e velocidade de execução, todavia, seus idiomas não estão completos, é preciso utilizar apenas o PORTUGUÊS para evitar uma serie de erros.\n\n[NATH-ÍRIS] → A única vantagem da MAIN são os idiomas funcionais.\nTodavia, a versão 3.2.7 igualou ambas as versões.\n"
				select vr in "Dev" "Main"; do
					case $vr in
						"Dev")
							git clone -b dev https://github.com/KillovSky/iris.git
							break
						;;
						"Main")
							git clone https://github.com/KillovSky/iris.git
							break
						;;
					esac
				done
				if ! [ -d "iris" ]; then
					printf "[NATH-ÍRIS] → Alguma coisa deu errado ao fazer o clone da Nath-Íris, verifique manualmente."
					exit
				else
					printf "[NATH-ÍRIS] → Pronto, o Git Clone foi finalizado com sucesso, irei limpar o terminal em 10 segundos...\n\n"
					sleep 10
					clear
					cd iris
					printf "[NATH-ÍRIS] → Quer fazer a instalação da Nath-Íris agora?\n\n"
					select is in "Sim" "Não"; do
						case $is in
							"Sim")
								printf "[NATH-ÍRIS] → Aguarde...fazendo instalação...\n\n"
								npm i
								printf "[NATH-ÍRIS] → A instalação terminou, deseja tentar iniciar?\n\n"
								select str in "Sim" "Não"; do
									case $str in
										"Sim")
											printf "${message}[NATH-ÍRIS] → Qual opção acima (número) você deseja usar para inciar a Nath-Íris após atualizar?\nVocê escolhe utilizar a -> "
											read selectOpt
											bash tools.sh $selectOpt
											exit
										;;
										"Não")
											printf "[NATH-ÍRIS] → Até a próxima, obrigado por instalar!"
											exit
										;;
									esac
								done
							;;
							"Não")
								printf "[NATH-ÍRIS] → Que pena, espero que você volte depois e faça a instalação..."
								exit
							;;
						esac
					done
				fi
			;;
			"Sair")
				printf "[NATH-ÍRIS] → Foi um prazer, volte sempre!\n"
				exit
			;;
		esac
	done
fi