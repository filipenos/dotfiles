#/bin/sh

aeremote -h >/dev/null 2>&1 || go get -u ronoaldo.gopkg.net/aetools/aeremote

exec aeremote "$@"
