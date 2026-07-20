# Quokka OS — show quokkafetch once per interactive login shell.
# Deployed to /etc/profile.d/quokka-fetch.sh
case "$-" in
    *i*)
        if [ -z "$QUOKKA_FETCH_SHOWN" ] && [ -x /usr/local/bin/quokkafetch ]; then
            export QUOKKA_FETCH_SHOWN=1
            /usr/local/bin/quokkafetch
        fi
        ;;
esac
