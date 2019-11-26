# Bash history
!! # executes last command in history
!58 # executes 58th command in history
!ssh # executes last command starting with ssh
!?ssh # executes last command containing the string ssh
echo !$ # echos last argument of last command
echo !*  # echos all but first word of last command
echo $? # echos exit status of last command
echo $@ # echos all arguments given to the script
echo $# # echos the number of arguments given to the script
^echo # executes last command without echo
^eth0^lo^ # executes last command substituting eth0 with lo
history -a # appends current session history to history file
pushd +n, popd, dirs -v
# This keeps the password out of the bash history; type the password and press Ctrl+d:
PASSWD=$(cat)


# Environment and Shell Options
exec bash # replaces bash shell with new bash shell
grep -l PATH ~/.[^.]*  # finds file in ~ that sets PATH
.bash_profile # User specific environment and startup programs, also sources .bashrc
export PS1="\[\033[1;31m\][\u@\h \w]# \[\033[0m\]"  # light red root prompt
export PS1="\[\033[1;32m\][\u@\h \w]$ \[\033[0m\]"  # light green user prompt
.bashrc # User specific aliases and functions, also sources /etc/bashrc
alias grep='grep --color' # color greps
alias # prints aliases
alias grep # prints the alias for grep
env # prints environment variables
export -p # prints environment variables
# press $ Tab Tab (prints environment variables)
set # prints names and values of all current shell variables
set -o emacs # emacs style line editing
set -x # turn on execution tracing, use in scripts to print commands during execution
set +x # turn off execution tracing


# Redirection...
# File descriptors: 0 stdin, 1 stdout, 2 strerr
grep calc * 2> err.log # redirects stderr to file
grep calc * &> err.log # redirects stdout and stderr to file; useful if no read
grep calc * > err.log 2>&1 # redirects stderr to stdout; seems same as using &>
grep calc * > err.log 1>&2 # redirects stdout to stderr which in this case is tty
grep calc < err.log # redirects stdin to grep, same as ‘grep cacl err.log’
./prime_gen.py < /dev/null # EOFError, redirects stdin to /dev/null so the script doesn’t hang on user input
./prime_gen.py <&- # IOError, closes stdin so the script doesn’t hang on user input
nohup ./ps1b.py & # run ps1b.py in the background, ignore hangup signal
nohup mydaemonscript 0<&- 1>/dev/null 2>& &
nohup mydaemonscript >>/var/log/myadmin.log 2>&1 <&- &
>&-  (closes stdout)

# Create file test1.txt with the lines below; the single quotes prevent command evaluation:
cat <<'EOF' > test1.txt
apple
`ls -l`
EOF

# Set the second listed version of java as the system default:
alternatives --config java << EOF
2
EOF

# Get system info:
ssh gp@tester1 << EOF
uname -a
lsb_release -d
EOF


# Loops and Tests
for i in `seq -w 0 20`; do touch file.$i; done # creates 20 files with padding for zeros
for((j=0; j<9; j++)); do echo $j; done # C-style for loop
ls -d */ 2> /dev/null | wc -l # returns the number for dirs only
while [ -f errors.log ]; do echo 'file exists'; sleep 1; done
while [ ! -d log ]; do echo 'log directory does not exist'; sleep 1; done
test $? == 0 && echo success || echo fail
[ $? == 0 ] && echo success || echo fail
if [ $? == 0 ]; then echo success; else echo fail; fi
c=17; f=15
[ $f < $c ] && echo true || echo false # results in error, $f and $c are interpreted as filenames
[[ $f < $c ]] && echo true || echo false # true
[ -z $FIRST_AVAIL_IP ] && echo "zero length"
[ ! $FIRST_AVAIL_IP ] && echo "zero length"
[ ! -z $FIRST_AVAIL_IP ] && echo "not zero length"

# Get user input from a script:
echo -n "Enter CVS username: "
read user

# Run commands from a file using a while-loop:
cat commands.txt | while read CMD; do echo $CMD; eval $CMD; done
while read CMD; do echo $CMD; eval $CMD; done < commands.txt

# Run commands from a file using a for-loop:
IFS=$'\n'
for CMD in `cat commands.txt`; do echo $CMD; eval $CMD; done
unset IFS

# Returns the total count of files/dirs unless a file has spaces in the name:
COUNT=0; for FILE in `ls`; do COUNT=$((COUNT + 1)); done; echo $COUNT

# A simple prime number generator finding prime numbers 2 through 100: 
for i in $(seq 2 100); do for j in $(seq 2 $((i / 2))); do [ $((i % j)) == 0 ] && i="" && break; done; [ -n "$i" ] && echo $i; done

# Monitor disk usage on the root filesystem:
i=0; while i=$((i + 1)); do df -h / | grep "..[0-9]%"; sleep 15; [ $i == $(($(tput lines) - 2)) ] && i=0 && echo -e "\e[1;31m`hostname`\e[00m `date +%T`"; done

# Similar to above, but without using tput.  Eventually though “i“’ would become out of range.
i=0; while i=$((i + 1)); do df -h / | grep "..[0-9]%"; sleep 15; ((i % 20 == 0)) && echo -e "\e[1;31m`hostname`\e[00m `date +%T`"; done

# “While loop” file-test with a red/green spinner:
while [ -d /etc ]; do printf "\r \e[31m[/]\e[00m"; sleep 0.5; printf "\r \e[32m[-]\e[00m"; sleep 0.5; printf "\r \e[31m[\\]\e[00m"; sleep 0.5; printf "\r \e[32m[|]\e[00m"; sleep 0.5; done; echo

# “Do while loop” that checks if a file exists:
while true; do [ -f nothing3.txt ] && echo "file present" || { echo "file not present"; break; }; sleep 2; done

# Status bar:
for i in `seq 1 10`; do printf "\e[31m#\e[00m"; sleep 0.5; done; printf "\rDone      "; echo


# Bitwise Operators...
# The left number in the double parenthesis is a decimal.
# The right number is the binary shift.
# With every shift, the decimal is either doubled or halved.

# The decimal 1 (binary: 1) shifted 8 places to the left becomes 256 (binary: 1 0000 0000)
echo $((1<<8))
# 256

# The decimal 8 (binary: 1000) shifted 1 place to the left becomes the decimal 16 (binary: 1 0000)
echo $((8<<1))
# 16

# The decimal 3 (binary: 11) shifted 2 places to the left becomes 12 (binary: 1100)
echo $((3<<2))
# 12

# The decimal 12 (binary: 1100) shifted 2 places to the right becomes 3 (binary: 11)
echo $((12>>2))
# 3


# Pass shell variables to a python command; in this example, -c is sys.argv[0] and $COLOR is sys.argv[1].
COLOR=green
python -c "import sys; print sys.argv[1].lower()" $COLOR
# green

# The above in a Bash function:
lower() { python -c "import sys; print sys.argv[1].lower()" $1; }
lower BLUE
# blue


# Arrays...
arr[0]=asdf1234
arr[1]=777
arr[2]=black

colors=([91]=red [92]=yellow [93]=yellow)
 
echo ${arr[@]} # This prints all elements in the array
asdf1234 777 black
echo ${#arr[@]} # prints the number of elements in the array (length of the array)
# 3
echo ${#string[0]} # prints the length of the first element
# 8
echo ${#string[1]} # prints the length of the second element
# 3
echo ${#string[2]} # prints the length of the third element
# 5


# Subshells and Code Blocks
touch nothing
test -f nothing || cd / && ls # ls runs on current dir
test -f nothing || { cd / && ls; } # neither cd nor ls runs
rm nothing
test -f nothing || { cd / && ls; }  # ls is run on / and the current dir is now /
test -f nothing || (cd / && ls) # ls is run on / but the current dir does not change

# Redirect output of a subshell to a script or command:
./stack-check.sh <(cat hostlist.txt | grep -v dc1)

# Redirect output from two subshells to diff:
diff <(ssh host1 "cat /config/bigip.conf") <(ssh host2 "cat /config/bigip.conf")

# Redirect output from tailing a log to terminal and two separate subshells: 
tail -f words.log | tee >(grep leaf > leaves.txt) >(grep apple > apples.txt)

# Run script on remote host over ssh:
ssh USER@$HOSTNAME /bin/bash < drhloggzip-ssh.sh

# The script below uses subshells and background execution to run commands in parallel.
# The "wait" ensures the terminal will not display a prompt until execution is complete and also that the terminal will in fact display a prompt when processing is complete.
# Invoking subshells isn’t absolutely necessary in this example.

#!/bin/bash
# Example usage: ./ppss.sh 3 scriptA scriptB scriptC scriptD scriptE
MAXFORKS=$1
shift
FORKS=0
for SCRIPT in $@; do
    if [ $FORKS -ge $MAXFORKS ]; then
        wait
        FORKS=0
    fi
    echo "Working on $SCRIPT"
    ($SCRIPT) &
    FORKS=$(( $FORKS + 1 ))
done
wait


# Evaluation, Expansion...
VAR1=apple
VAR2="orange
grape"
echo $VAR1 # apple
echo "$VAR1" # apple
echo "$VAR2" # line1: orange; line 2: grape
echo '$VAR1' # $VAR1
echo cart$VAR1 # cartapple
echo $VAR1cart # (no output)
echo ${VAR1}cart # applecart
VAR1=${VAR1}cart; echo $VAR1 # applecart
echo a{pp,,is}le # apple ale aisle
VAR3=ORANGEapple
echo ${VAR3,,} # orangeapple
echo ${VAR3^^} # ORANGEAPPLE

REGEXs_EGREP_ARGS=" -e 208.79.249 -e 208.79.253 -e 207.67.0 -e 207.67.50"
echo $REGEXs_EGREP_ARGS # 208.79.249 -e 208.79.253 -e 207.67.0 -e 207.67.50
echo "$REGEXs_EGREP_ARGS" # -e 208.79.249 -e 208.79.253 -e 207.67.0 -e 207.67.50

touch img.{00..23} # creates img.00 through img.23
ls img.{00..09} # matches the first 10

touch apple
ls ap?le # apple (matches any one char)
ls a*le # apple (matches patterns beginning with a, ending with le)

VAR2=yellow ./fruit.sh; echo $VAR2
# yellow pear (VAR2 is only set for the 1st command)

# Useful if the ls command is hanging on a broken symlink
# Also good practice before using rm on multiple files
echo *

ffpid="ps -e | grep firefox"
eval $ffpid
# 8393 ?        01:01:43 firefox

alias insert='printf "|%s|\n"'
insert "camera operator"
# |camera operator|

basename $0 # filename of the script being run
dirname $0 # relative path of the script being executed
readlink -f $0 # full path and filename of the script being run


chsh -s /bin/zsh # set zsh as default shell on OSX
