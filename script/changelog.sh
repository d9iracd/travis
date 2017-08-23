#!/bin/bash
echo -----------------CHANGELOG-------------------
if [[ "$TRAVIS_BRANCH" == "master" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then
    echo ---------------TRAVIS_BRANCH----------------
    echo $TRAVIS_BRANCH
    echo ------------------CONFIG--------------------
    git config --global user.email $GH_EMAIL
    git config --global user.name "Travis CI"
    # git config --global push.followTags true
    git remote remove origin
    git remote add origin https://$GH_USER:$GH_TOKEN@github.com/d9iracd/travis.git
    echo ------------------RELEASE--------------------
    
    if [[ $TRAVIS_COMMIT_MESSAGE != *"**version**"* && $TRAVIS_COMMIT_MESSAGE != *"**CHANGELOG.md**"* ]]; then
        git checkout master -f
    fi
    
    npm run release -- -m "ci(release): generate **CHANGELOG.md** for version %s"
    # # Get version number from package
    export GIT_TAG=$(jq -r ".version" package.json)
    conventional-github-releaser -t $GH_TOKEN -r 0
    # # Update CFBundleShortVersionString   
    echo $GIT_TAG >> tag.txt
    git add -A
    # Rename last commit
    git commit -m "ci(build): increment **version** ${GIT_TAG}"

    git push origin master
    
else
    echo $TRAVIS_BRANCH
fi
