#! /usr/bin/env bash
$EXTRACTRC `find src themes -name \*.kcfg -o -name \*.ui` >> rc.cpp || exit 11
$XGETTEXT rc.cpp `find src themes -name \*.cpp -o -name \*.qml` -o $podir/aurorae.pot
rm -f rc.cpp
