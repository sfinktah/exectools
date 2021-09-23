function last {
    array=("${@}")
    last_index=$(( $# - 1 ))
    last_item=${array[$last_index]}
    echo "$last_item"
}
python setup.py sdist
files=$( ls dist/*.tar.gz | sort -V )
lastfile=$( last $files )
version=${lastfile##*-}
version=${version%.tar.gz}
echo $version
twine check "$lastfile"
twine upload "$lastfile"
test -e .git || {
    git-repo exectools
    rm README.md
    git add LICENSE.txt README.rst setup.py version.txt update.sh test.sh prod.sh exectools/*.py
    git commit -m 'first commit'
    git push
}
git add -u
git add exectools/*.py
git commit -m "0.0.1"
git push
sleep 15
python -m pip install exectools==$version
cmd /c "python -m pip install exectools==$version"
