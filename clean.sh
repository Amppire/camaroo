#! /bin/bash

echo
echo '---------------------------'
echo '------- ./clean.sh --------'
echo '---------------------------'
echo

find . -type f -name '*.lock' -delete

for i in App Packages/*;  do
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
