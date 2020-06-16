#!/bin/bash

# looks like: FROM registry.access.redhat.com/ubi8-minimal:8.2-267 AS foobar
FROM_LINE=$(grep -m 1 FROM Dockerfile)

# looks like: registry.access.redhat.com/ubi8-minimal:8.2-267
#IFS=':'; IMG_SPEC=$(echo $FROM_LINE | sed 's/FROM \([^ ]\+\).*/\1/'); unset IFS
IMG_SPEC=$(echo $FROM_LINE | sed 's/FROM \([^ ]\+\).*/\1/')

# looks like: registry.access.redhat.com/ubi8-minimal
IMG_BASE=$(echo $IMG_SPEC | cut -d ':' -f 1)
# looks like: 8.2-267
CUR_VER=$(echo $IMG_SPEC | cut -d ':' -f 2)

# looks like: X.X-X
GET_VER_FMT='s/[1234567890]\+/X/g'
CUR_VER_FMT=$(echo $CUR_VER | sed $GET_VER_FMT)

REPO_HOST=$(dirname $IMG_BASE)
IMG_NAME=$(basename $IMG_BASE)

ALL_TAGS=$(curl -L https://${REPO_HOST}/v2/${IMG_NAME}/tags/list | jq '.tags' | jq -r '.[]' | sort -V -r)

for tag in $ALL_TAGS; do
    tag_fmt=$(echo $tag | sed $GET_VER_FMT)
    if [ "$tag_fmt" == "$CUR_VER_FMT" ]; then
        NEW_VER="$tag"
	break
    fi
done

if [ "$NEW_VER" != "$CUR_VER" ]; then
    NEW_IMG_SPEC="${IMG_BASE}:${NEW_VER}"
    echo "Upgrading to: $NEW_IMG_SPEC"
    sed -i "s|${IMG_SPEC}|${NEW_IMG_SPEC}|" Dockerfile
    exit 0
fi

echo "Keeping: $IMG_SPEC"
