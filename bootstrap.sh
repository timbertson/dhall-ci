#!/usr/bin/env bash
function _ {
	set -euo pipefail
	dest="${1:-$PWD}"
	branch="${BRANCH_OVERRIDE:-master}"
	base_uri="https://raw.githubusercontent.com/timbertson/dhall-ci/$branch"

	cd "$dest"
	function download {
		echo "Fetching $base_uri/$1 -> $2"
		mkdir -p "$(dirname "$2")"
		curl --fail --silent --show-error -L "$base_uri/$1" -o "$2"
	}

	echo "Populating initial expressions in $dest/dhall from $base_uri ..."
	mkdir -p "dhall/dependencies"
	echo 'https://raw.githubusercontent.com/timbertson/dhall-ci/master/package.dhall' > dhall/dependencies/CI.dhall
	echo 'https://raw.githubusercontent.com/timbertson/dhall-render/master/package.dhall' > dhall/dependencies/Render.dhall
	download "dhall/bootstrap-files.dhall" "dhall/files.dhall"
	download "generated/dhall/bump" "generated/dhall/bump"
	chmod +x generated/dhall/bump

	for f in CI Render; do
		echo "Pinning dhall/dependencies/$f.dhall ..."
		generated/dhall/bump --freeze-cmd='dhall freeze --inplace' dhall/dependencies/$f.dhall
	done

	# now use these minimal files to run the initial generation:

	dhall_file="./dhall/files.dhall"
	echo -e "\nRunning bootstrapped render ..."
	echo "( $dhall_file )"'.files.`dhall/render`.contents' | dhall text | ruby
	echo -e "\nRunning test render ..."
	./dhall/render
	echo -e "\nSuccess!"
}

_
