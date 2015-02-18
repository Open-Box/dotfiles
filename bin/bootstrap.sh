#!/usr/bin/env bash
########################

# Echoes all commands before executing.
#set -v

# Abort script at first error
set -e

#
# bootstrap installs things.

[[ "$1" == "source" ]] || \

echo 'Dotfiles - Open-Box - http://www.open-box.it/'

if [[ "$1" == "-h" || "$1" == "--help" ]]; then cat <<HELP

Usage: $(basename "$0")

See the README for documentation.
https://github.com/Open-Box/dotfiles

Licensed under the GNU GENERAL PUBLIC LICENSE Version 3
https://github.com/Open-Box/dotfiles/blob/master/LICENSE.md
HELP
exit; fi

###########################################
# GENERAL PURPOSE EXPORTED VARS / FUNCTIONS
###########################################

########## Variables

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd)

# importing function file
functions_file="$DOTFILES_ROOT/bash/functions.bash"
if [ -f $functions_file ]
then
    source $functions_file
else
    echo "no function file ($function_file) found. exit"
    exit 1
fi 

#printf "\r [ \033[0;33m?\033[0m ] $1 "

###########################################
# INTERNAL DOTFILES "INIT" VARS
###########################################


current_user=$(whoami)

e_header "Current User: $current_user"

dir=$DOTFILES_ROOT
#dir=~/dotfiles                    # dotfiles directory
#olddir=~/dotfiles_old             # old dotfiles backup directory
backup_dir="$dir/backups/$(date "+%Y_%m_%d-%H_%M_%S")"
backup=

files=".bashrc .bash_profile .gitconfig .gitignore_global "        # list of files/folders to symlink in homedir

###########################################
# INTERNAL DOTFILES FUNCTIONS
###########################################


# For testing.
function assert() {
  local success modes equals actual expected
  modes=(e_error e_success); equals=("!=" "=="); expected="$1"; shift
  actual="$("$@")"
  [[ "$actual" == "$expected" ]] && success=1 || success=0
  ${modes[success]} "\"$actual\" ${equals[success]} \"$expected\""
}

# Backup Files
function backup_header() { e_header "backing up files to $backup_dir ."; }
function backup_do() {
  local source_file=~/$1
  #source_file=~/sym
  echo "Backing up $source_file........"
  #is_regular_file $source_file
  if [ 1 -eq $(is_regular_file $source_file) ]
  then
    echo "is regular file"
    cp $source_file $backup_dir/$1
  fi

if [ 1 -eq $(is_symlink_file $source_file) ]
  then
    echo "is symlink file"
    cp $source_file $backup_dir/$1
  fi

  if [ 1 -eq $(is_regular_directory $source_file) ]
  then
    echo "is regular directory"
    mkdir -p $backup_dir/$1
    cp -a  $source_file $backup_dir/$1
  fi
  
  if [ 1 -eq $(is_symlink_directory $source_file) ]
  then
    echo "is symlink directory"
    mkdir -p $backup_dir/$1
    cp -a  $source_file $backup_dir/$1
  fi
  
  
  #ln -sf ${2#$HOME/} ~/
  e_success " done."  
}


# Copy files.
function copy_header() { e_header "Copying files into home directory"; }
function copy_test() {
  if [[ -e "$2" && ! "$(cmp "$1" "$2" 2> /dev/null)" ]]; then
    echo "same file"
  elif [[ "$1" -ot "$2" ]]; then
    echo "destination file newer"
  fi
}
function copy_do() {
  echo "Copying ~/$1........"
  cp "$2" ~/
  e_success " done."
}

# Link files.
function link_header() { e_header "Linking files into home directory"; }
function link_test() {
  [[ "$1" -ef "$2" ]] && echo "same file"
}
function link_do() {
  echo "Linking ~/$1........"
  ln -sf ${2#$HOME/} ~/
  e_success " done."  
}



link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user_question "File already exists: $(basename "$src"), what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      e_success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      e_success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      e_success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    e_success "linked $1 to $2"
  fi
}


###### git init

check_requires() {

e_header "check_requires"

# Ensure that we can actually, like, compile anything.
if [[ ! "$(type -P gcc)" ]] && is_osx; then
  e_error "XCode or the Command Line Tools for XCode must be installed first."
  exit 1
fi

# If Git is not installed, install it (Ubuntu only, since Git comes standard
# with recent XCode or CLT)
if [[ ! "$(type -P git)" ]] && is_ubuntu; then
  e_header "Installing Git"
  sudo apt-get -qq install git-core
fi

# If Git isn't installed by now, something exploded. We gots to quit!
if [[ ! "$(type -P git)" ]]; then
  e_error "Git should be installed. It isn't. Aborting."
  exit 1
fi

e_success "check_requires"
}

setup_gitconfig () {
  e_header 'setup gitconfig'
  local source_file
  source_file="$dir/config/gitconfig.example"

  dest_file=.gitconfig
  if [ -f $source_file ]
  then
    #git_credential='cache'
    #if [ "$(uname -s)" == "Darwin" ]
    #then
    #  git_credential='osxkeychain'
    #fi
    echo "source file: $source_file"

    backup_header
    backup_do $dest_file  
    
    user_question ' - Setup your git username...'
    read -e git_authorname
    user_question ' - Setup your git email...'
    read -e git_authoremail
  
    

    #cp "$source_file"  ~/temp.txt
    sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/USERNAME/$current_user/g" $source_file > ~/$dest_file

    echo "Setting propetary....."
    chown $current_user:$current_user ~/$dest_file
    
    e_success 'setup_gitconfig'
    
  else 
    e_error "git config file doesn't exist"
    e_error "setup_gitconfig terminated"
  fi
}

install_dotfiles () {
    e_header 'installing dotfiles.....'
    local overwrite_all=false backup_all=false skip_all=false
    for src in $(find "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink')
    do
        dot_file=".$(basename "${src%.*}")"
        dst="$HOME/$dot_file"
        echo "$src"
        echo "$dst"
        backup_do $dot_file
        link_file "$src" "$dst"
    done
    e_success '....done!'
}



##########
# Enough with the functions, let's do stuff.

export prompt_delay=5

e_arrow "current OS: $(get_os)"

check_requires

# create dotfiles_old in homedir
if [ ! -d "$backup_dir" ]; then
    e_header "Creating $backup_dir for backup of any existing dotfiles in ~"
    mkdir -p $backup_dir
    e_success "...done"
fi

# change to the dotfiles directory
e_header "Changing to the $dir directory"
cd $dir
e_success "...done"

#### uncomment for overwrite gitcopy file
#setup_gitconfig

### symlinking stuff
install_dotfiles

# Execute code for each file in these subdirectories.
#do_stuff "bash"
#do_stuff "git"
#do_stuff "java"
#do_stuff "android"


##### RE-LOADING SOURCE
#source ~/.bashrc
