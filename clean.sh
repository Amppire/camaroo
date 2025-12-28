#! /bin/bash

echo
echo '---------------------------'
echo '------- ./clean.sh --------'
echo '---------------------------'
echo

find . -type f -name '*.lock' -delete

list=(App Packages/storage Packages/camera_info/platform_interface Packages/camera_info/ios Packages/camera_info/android Packages/camera_info)

for i in ${list[@]}; do
	pushd $i
		if [ -f "clean.sh" ]
		then
			./clean.sh
		else
			flutter clean
			flutter pub get
		fi
	popd
done
