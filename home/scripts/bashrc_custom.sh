#ALIAS
alias ls="ls --color=auto"
alias ll="ls -lih --color=auto"
alias eclipse="/opt/eclipse/eclipse"
alias lampp="sudo /opt/lampp/lampp"
alias lampp-gui="sudo /opt/lampp/manager-linux-x64.run"
alias xnview="/opt/XnView/xnview.sh"
alias aptu="sudo apt update && sudo apt upgrade"
alias docker="sudo docker"

alias savedata="~/scripts/savedata.sh"
alias savephone="~/scripts/savephone.sh"
alias diag="~/scripts/diag.sh"
alias clean_kernel="~/scripts/clean_kernel.sh"
alias sysclean="~/scripts/sysclean.sh"

#EXPORT

export PATH="/opt/lampp/bin:$PATH"
export PATH="/opt/phpunit/bin:$PATH"

# Add JBang to environment
alias j!=jbang
export PATH="$HOME/.jbang/bin:$PATH"

#COMMANDS
xset -b
#linuxlogo -L 11 -t "T470"

#FUNCTIONS
clock() {
	clear;
	while [ 1 ]; do
		date | cut -d " " -f 5; sleep 1;
		clear;
	done;
}

pdf_light() {
	gs -sDEVICE=pdfwrite -dPDFSETTINGS=/screen -dNOPAUSE -dBATCH -sOutputFile=$2 $1
}

flac2mp3() {
	for FILE in *.flac;
	do
		ffmpeg -i "$FILE" -ab 320k -map_metadata 0 "${FILE%.*}.mp3";
	done
}

purple_prompt() {
	PS1='\[\033[00;35m\]\u@\h:\w\$\[\033[00m\]'
}
blue_prompt() {
	PS1='\[\033[01;34m\]\u@\h:\w\$\[\033[00m\]'
}
red_prompt() {
	PS1='\[\033[0;31m\]\u@\h:\w\$\[\033[0;0m\]'
}

docker_clean() {
	docker system df

	docker stop `docker ps -a -q`

	for i in `docker image list --format "table {{.ID}};{{.Repository}};{{.Tag}};{{.Size}}" | grep "<none>" | cut -d ";" -f 1`; do
		docker rmi $i
	done
	
	docker system prune -f --volumes
	
	docker system df
}
