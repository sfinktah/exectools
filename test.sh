function last {
    array=("${@}")
    last_index=$(( $# - 1 ))
    last_item=${array[$last_index]}
    echo "$last_item"
}
perl -pi -e 's/VERSION="[^"]+"/VERSION="'$(cat version.txt)'"/' setup.py
python setup.py sdist
files=$( ls dist/*.tar.gz | sort -V )
lastfile=$( last $files )
version=${lastfile##*-}
version=${version%.tar.gz}
echo $version
twine check "$lastfile"
twine upload --repository pypitest "$lastfile"
echo "Install at:"
echo "python -m pip install -i https://test.pypi.org/simple/ exectools==$version"
sleep 15
# python -m pip install --upgrade --index-url https://test.pypi.org/simple/ exectools
echo "Updating cygwin pip"
python -m pip install -i https://test.pypi.org/simple/ exectools==$version
# echo 'call "c:\Program Files (x86)\Microsoft Visual Studio\2017\Community\vc\Auxiliary\Build\vcvarsall.bat" x64' $'\n' "$@" | cmd 
echo "Updating windows pip"
cmd /c "python -m pip install -i https://test.pypi.org/simple/ exectools==$version"
