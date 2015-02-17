#!/usr/bin/env bash
#
# bootstrap installs things.

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd)
set -e


########## Variables

current_user=$(whoami)

echo "Current User: $current_user"

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files=".bashrc .bash_profile .gitconfig .gitignore_global "        # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do

    source_file=$dir/$file
    dest_file=~/$file
    if [ ! -f "$source_file" ]; then
	   echo "source file $source_file doesn't exist"
    else

        #echo "Moving any existing dotfiles from ~ to $olddir"
        #mv ~/$file ~/dotfiles_old/
        #echo "Creating symlink to $file in home directory."
        #ln -s $dir/$file ~/$file
        echo "Setting propetary....."
        chown $current_user:$current_user $dest_file
    fi

done

##### RE-LOADING SOURCE
#source ~/.bashrc
