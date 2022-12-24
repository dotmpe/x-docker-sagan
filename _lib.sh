addhosts ()
{
  grep -vE '^\s*(#.*)?$' "$@" | while read -r ipaddr hostname aliases
    do
      printf -- '--add-host %s:%s ' "$hostname" "$ipaddr"
      test -z "$aliases" && continue
      for als in $aliases
      do
        printf -- '--add-host %s:%s ' "$als" "$ipaddr"
      done
    done
}

saganhosts ()
{
  test -e ./hosts && return
  test ! -h ./hosts || rm ./hosts
  ln -vs ${UCONF:?}/etc/host/lab.tab hosts
}

saganrules ()
{
  test -d ../sagan-rules && {
    ( cd ../sagan-rules && git pull ) || exit
  } || {
    git clone http://github.com/quadrantsec/sagan-rules ../sagan-rules
  }
}

#
