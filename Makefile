setup:
	curl -Ls https://install.tuist.io | bash

generate: 
	tuist generate
	sh SetupMockingbird.sh

movieApi: 
	tuist focus MovieApi