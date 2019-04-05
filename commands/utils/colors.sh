#  Copyright 2013 Manuel Gutierrez <dhunterkde@gmail.com>
#  https://github.com/xr09/rainbow.sh
#  Bash helper functions to put colors on your scripts
#
#  Usage example:
#  green=$(green "Grass is green")
#  echo "Coming next: $green"
#

__RAINBOWPALETTE="1"

function __color()
{
  echo -e " \e[$__RAINBOWPALETTE;$2m$1\e[0m"
}

function green()
{
  echo $(__color "$1" "32")
}

function red()
{
  echo $(__color "$1" "31")
}

function blue()
{
  echo $(__color "$1" "34")
}

function purple()
{
  echo $(__color "$1" "35")
}

function yellow()
{
  echo $(__color "$1" "33")
}

function cyan()
{
  echo $(__color "$1" "36")
}

