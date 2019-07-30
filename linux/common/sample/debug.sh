#!/bin/bash

color_def="~/.colorrc"

if [[ -f $color_def ]]; then
    . $color_def
else

 # color definitions
 black="$(tput setaf 0)"
 darkgrey="$(tput bold ; tput setaf 0)"
 lightgrey="$(tput setaf 7)"
 white="$(tput bold ; tput setaf 7)"
 red="$(tput setaf 1)"
 lightred="$(tput bold ; tput setaf 1)"
 green="$(tput setaf 2)"
 lightgreen="$(tput bold ; tput setaf 2)"
 yellow="$(tput setaf 3)"
 blue="$(tput setaf 4)"
 lightblue="$(tput bold ; tput setaf 4)"
 purple="$(tput setaf 5)"
 pink="$(tput bold ; tput setaf 5)"
 cyan="$(tput setaf 6)"
 lightcyan="$(tput bold ; tput setaf 6)"
 nc="$(tput sgr0)" # no color

fi

export darkgrey lightgreywhite red lightred green lightgreen yellow blue export lightblue purple pink cyan lightcyan nc

if ! $lc; then

 lc=$cyan
fi

if ! $sc; then

 sc=$yellow
fi
if ! $lnc; then

 lnc=$red
fi
if ! $fc; then

 fc=$green
fi

if ! $cc; then

 cc=$white
fi

export sc lnc fc

reset_screen() {

 echo $nc
}

reset_screen

usage()
{
cat <<'EOF'
usage: debug [option] script arguments
possible options are:

- help|usage: print this screen
- verbose: sets -xv flags
- noexec: sets -xvn flags
- no parameter sets -x flags
EOF

fmt << 'EOF'

 if the script takes arguments remember to enclose the script and arugments
 in ""
EOF

fmt <<EOF

The script prints the script name, script line number and function name as it
executes the script. The various parts of the script prompt are printed in
color. If the default colors are not suitable than you can set the environment
varialbes script_color linenum_color funcname_color to any of the following
colors: ${darkgrey}darkgrey$nc, ${lightgrey}light grey$nc, ${white}white,
${red}red, ${lightred}light red, ${green}green, ${lightgreen}light green,
${yellow}yellow, ${blue}blue, ${lightblue}light blue, ${purple}purple,
${pink}pink, ${cyan}cyan, ${lightcyan}light cyan$nc.
EOF


cat <<EOF

default colors are:
${level_color}- shell level color:cyan$nc
${script_color}- script name: yellow$nc
${linenum_color}- line number: red$nc
${funcname_color}- function name: green$nc
${command_color}- command executed: white'$nc
EOF

}


debug_cmd() {

 trap reset_screen INT
 /bin/bash $FLAGS $SCRIPT
}

if [ $# -gt 0 ]; then

 case "$1" in
       "test"|"compile")
          FLAGS=-n
          SCRIPT=$2
       ;;
       "verbose")
          FLAGS=-xv
          SCRIPT=$2
       ;;
       "noexec")
          FLAGS=-xvn
          SCRIPT=$2
       ;;
       "help"|"usage")
          usage
          exit 3
       ;;
       *)
          FLAGS=-x
          PS4="${white}${lc}+${sc}"'(${BASH_SOURCE##*/}'":${lnc}"'${LINENO}'"${sc}): ${fc}"'${FUNCNAME[0]}'"(): ${cc}"
          export PS4
          SCRIPT=$1
       ;;
 esac
 debug_cmd
else

 usage
fi

reset_screen
