# shellcheck disable=SC1090,SC2148

myzs-upload() {
	test -z "$MYZS_ROOT" && echo "\$MYZS_ROOT is required" && exit 2

	cd "$MYZS_ROOT" || exit 1
	echo "Start upload current change to github"
	git status --short

	./deploy.sh
}
