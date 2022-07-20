#!/bin/sh

$DC_VERSION="latest"
OWASPDC_DIRECTORY=$HOME/OWASP-Dependency-Check
DATA_DIRECTORY="$OWASPDC_DIRECTORY/data"
REPORT_DIRECTORY="$OWASPDC_DIRECTORY/reports"
CACHE_DIRECTORY="$OWASPDC_DIRECTORY/data/cache"

chmod -R 777 "$OWASPDC_DIRECTORY"

if [ ! -d "$DATA_DIRECTORY" ]; then
    echo "Initially creating persistent directories"
    mkdir -p "$DATA_DIRECTORY"
    chmod -R 777 "$DATA_DIRECTORY"

    mkdir -p "$REPORT_DIRECTORY"
    chmod -R 777 "$REPORT_DIRECTORY"
fi
if [ ! -d "$CACHE_DIRECTORY" ]; then
    echo "Initially creating persistent directory: $CACHE_DIRECTORY"
    mkdir -p "$CACHE_DIRECTORY"
    chmod -R 777 "$CACHE_DIRECTORY"
fi

# Make sure we are using the latest version
docker pull owasp/dependency-check:$DC_VERSION

docker run --rm \
    --volume $(pwd):/src:z \
    --volume "$DATA_DIRECTORY":/usr/share/dependency-check/data:z \
    --volume "$REPORT_DIRECTORY":/report:z \
    owasp/dependency-check:$DC_VERSION \
    --scan /src \
    --format "ALL" \
    --project "My OWASP Dependency Check Project" \
    --out /report
    # Use suppression like this: (/src == $pwd)
    # --suppression "/src/security/dependency-check-suppression.xml"
