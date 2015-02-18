# Source a file or .bash files in a directory
function src_file() {
    local file
    
    if [ 1 == $(is_regular_file $1) ]; then
        #source "$DOTFILES/source/$1.sh"
        source $1
    else
        #### source dei file path
        for file in $1/*.path; do
            source "$file"
        done
        ### source dei generici
        for file in $1/*.bash; do
            source "$file"
        done
        
        ### source dei completion
        for file in $1/*.completion; do
            source "$file"
        done
    fi
}


##### funzioni:




# OS detection
function is_osx() {
  [[ "$OSTYPE" =~ ^darwin ]] || return 1
}
function is_ubuntu() {
  [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1
}
function is_debian() {
  [[ "$(cat /etc/issue 2> /dev/null)" =~ Debian ]] || return 1
}
function is_mint_debian_edition() {
  [[ "$(cat /etc/issue 2> /dev/null)" =~ LMDE ]] || return 1
}

function get_os() {
  for os in osx ubuntu debian; do
    is_$os; [[ $? == ${1:-0} ]] && echo $os
  done
}


### test files
function is_regular_file() {
  if  ! [[ -L $1 || -d $1 ]] 
  then echo 1; 
  else echo 0; 
  fi
}

function is_regular_directory() {
  if  ! [[ -L $1 || -f $1 ]] 
  then echo 1; 
  else echo 0; 
  fi
}

function is_symlink_file() {
  if  [[ -L $1 && -f $1 ]] 
  then echo 1; 
  else echo 0; 
  fi
}

function is_symlink_directory() {
  if  [[ -L $1 && -d $1 ]] 
  then echo 1; 
  else echo 0; 
  fi
}



## fancy echoes
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }
function user_question()    { printf "\r [ \033[0;33m?\033[0m ] $1 \n"; }

#printf "\r [ \033[0;33m?\033[0m ] $1 "



#### generate random password
randpw(){ < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;}

