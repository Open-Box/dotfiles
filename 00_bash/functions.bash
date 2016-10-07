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

# external ip detection
function ext-ip () { curl http://ipecho.net/plain; echo; }



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


### Extract combines a lot of utilities to allow you to decompress just about any compressed file format
# from https://github.com/xvoland/Extract/blob/master/extract.sh
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f $1 ] ; then
        # NAME=${1%.*}
        # mkdir $NAME && cd $NAME
        case $1 in
          *.tar.bz2)   tar xvjf ../$1    ;;
          *.tar.gz)    tar xvzf ../$1    ;;
          *.tar.xz)    tar xvJf ../$1    ;;
          *.lzma)      unlzma ../$1      ;;
          *.bz2)       bunzip2 ../$1     ;;
          *.rar)       unrar x -ad ../$1 ;;
          *.gz)        gunzip ../$1      ;;
          *.tar)       tar xvf ../$1     ;;
          *.tbz2)      tar xvjf ../$1    ;;
          *.tgz)       tar xvzf ../$1    ;;
          *.zip)       unzip ../$1       ;;
          *.Z)         uncompress ../$1  ;;
          *.7z)        7z x ../$1        ;;
          *.xz)        unxz ../$1        ;;
          *.exe)       cabextract ../$1  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "$1 - file does not exist"
    fi
fi
}


### measure how long does it take to load an url

function perf1 {
  curl -o /dev/null -s -w "%{time_connect} + %{time_starttransfer} = %{time_total}\n" "$1"
# curl -o /dev/null -s -w "time_total: %{time_total} sec\nsize_download: %{size_download} bytes\n" "$1"
}


function perf2 {
  curl -o /dev/null -s -w "%{time_connect} + %{time_starttransfer} = %{time_total}\n" "$1"
# curl -o /dev/null -s -w "time_total: %{time_total} sec\nsize_download: %{size_download} bytes\n" "$1"
}

### dump MYSQL privileges for all users apart from root, phpmyadmin and debian-sys-maint. 
mygrants()
{
mysql -B -N $@ -e "SELECT DISTINCT CONCAT(
'SHOW GRANTS FOR ''', user, '''@''', host, ''';'
) AS query FROM mysql.user WHERE user NOT IN ('root','phpmyadmin','debian-sys-maint')"  | \
mysql $@ | \
sed 's/\(GRANT .*\)/\1;/;s/^\(Grants for .*\)/## \1 ##/;/##/{x;p;x;}'
}