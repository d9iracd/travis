
if [[ $TRAVIS_COMMIT_MESSAGE == *"#~CHANGELOG.md~#"* ]]; then
  travis cancel $TRAVIS_BUILD_NUMBER 
fi