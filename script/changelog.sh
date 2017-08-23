#!/bin/bash
echo -----------------CHANGELOG-------------------
if [[ "$TRAVIS_BRANCH" == "master" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then
    echo ------------------CONFIG--------------------
    git config --global user.email $GH_EMAIL
    git config --global user.name "Travis CI"
    # git config --global push.followTags true
    git remote remove origin
    git remote add origin https://$GH_USER:$GH_TOKEN@github.com/d9iracd/travis.git
    echo ------------------RELEASE--------------------
    
    if [[ $TRAVIS_COMMIT_MESSAGE != *"#~CHANGELOG.md~#"* ]]; then
        git checkout master -f
    fi
    
    npm run release
    # # Get version number from package
    export GIT_TAG=$(jq -r ".version" package.json)

    # # Update CFBundleShortVersionString   
    echo $GIT_TAG >> tag.txt
    git add -A
    # Rename last commit
    git commit --amend -m "ci(release): generate #~CHANGELOG.md~# for version ${GIT_TAG}"

    git push origin master
    conventional-github-releaser -t $GH_TOKEN -r 0
else
    echo $TRAVIS_BRANCH
fi
