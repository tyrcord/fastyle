dir="$(basename $PWD)"

if [ "$dir" == "example" ]; then
    cp ../../../scripts/assets/analysis_options.yaml ./
else
    cp ../../scripts/assets/analysis_options.yaml ./
fi

