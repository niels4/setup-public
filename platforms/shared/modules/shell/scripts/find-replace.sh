fd . src

rg "icons\/" src
 
perl -p -i -e 's/icons\//assets\/icons\//g' `fd . src`

perl -p -i -e 's|src/|live/|g' `fd . src`
