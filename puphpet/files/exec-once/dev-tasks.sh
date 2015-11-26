#!/bin/bash
echo "Now running custom dev tasks..."

if [ ! -x /usr/local/bin/git-fat ]; then
  echo 'Installing git-fat...'
  sudo curl -o /usr/local/bin/git-fat https://raw.githubusercontent.com/omikronsc/git-fat/master/git-fat  &>/dev/null
  sudo chmod 755 /usr/local/bin/git-fat
  echo '✔'

fi

if [ ! -x /usr/local/bin/semver ]; then
  echo 'installing semver...'
  sudo curl -o /usr/local/bin/semver https://raw.githubusercontent.com/fsaintjacques/semver-tool/develop/src/semver  &>/dev/null
  sudo chmod 755 /usr/local/bin/semver
  echo '✔'
fi


echo 'All Tasks Done'
