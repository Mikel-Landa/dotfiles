# POSIX PATH helpers. Sourced from ~/.profile.
# Idempotent: re-sourcing is a no-op for entries already in PATH.

path_push() {
    case ":${PATH}:" in
        *":$1:"*) ;;
        *) PATH="$1${PATH:+:$PATH}" ;;
    esac
}

path_push_back() {
    case ":${PATH}:" in
        *":$1:"*) ;;
        *) PATH="${PATH:+$PATH:}$1" ;;
    esac
}

path_remove() {
    case ":${PATH}:" in
        *":$1:"*) ;;
        *) return 0 ;;
    esac
    _new=""
    _saved_IFS=$IFS
    IFS=:
    for _d in $PATH; do
        if [ "$_d" != "$1" ]; then
            _new="${_new:+$_new:}$_d"
        fi
    done
    IFS=$_saved_IFS
    PATH=$_new
    unset _new _saved_IFS _d
}

export PATH
