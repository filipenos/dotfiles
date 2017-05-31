#/bin/sh

aeremote -h >/dev/null 2>&1 || go install ronoaldo.gopkg.net/aetools/aeremote

exec aeremote "$@"
