# Setting Shopt Builtin


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, Bash includes filenames beginning with a ‘.’ in the results of filename expansion. 
#shopt -s dotglob

# If set, the pattern ‘**’ used in a filename expansion context will match all files and zero or more directories and subdirectories. If the pattern is followed by a ‘/’, only directories and subdirectories match. 
#shopt -s globstar

# If set, the history list is appended to the file named by the value of the HISTFILE variable when the shell exits, rather than overwriting the file. 
shopt -s histappend

# If set, Bash allows filename patterns which match no files to expand to a null string, rather than themselves. 
#shopt -s nullglob
