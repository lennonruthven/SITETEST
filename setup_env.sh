#!/bin/bash
#set -u -e -o pipefail

GITHUB_ACTOR="lennonruthven"

# setup git
git config --global user.email "Lennonruthven@outlook.com"
git config --global user.name "Lennon Ruthven"
git config --global github.user "${GITHUB_ACTOR}"
git config --global github.token "${GH_TOKEN_OVERRIDE}"

[ -d "blog" ] && git rm -r --cached blog
rm -rf blog

git submodule add --force https://github.com/lennonruthven/hugo-codex-theme-template.git blog

./NotiGoCMS

cd blog
git status
git add *
git status
now=`date "+%Y-%m-%d %a"`

# "git commit" returns 1 if there's nothing to commit, so don't report this as failed build
set +e
git commit -am "ci: update from notion on ${now}"
if [ "$?" -ne "0" ]; then
    echo "nothing to commit"
    exit 0
fi
set -e
git push "https://${GITHUB_ACTOR}:${GH_TOKEN_OVERRIDE}@github.com/lennonruthven/hugo-codex-theme-template.git" master || true
cd ../
