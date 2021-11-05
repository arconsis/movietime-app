xcodebuild -resolvePackageDependencies
DERIVED_DATA="$(xcodebuild -showBuildSettings | pcregrep -o1 'OBJROOT = (/.*)/Build')"
REPO_PATH="${DERIVED_DATA}/SourcePackages/checkouts/mockingbird"

"${REPO_PATH}/mockingbird" install --target MovieTimeTests --sources MovieTime MovieApi
