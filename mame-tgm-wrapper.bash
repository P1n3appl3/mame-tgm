#!@runtimeShell@

set -euo pipefail

readonly MAME_TGM="@mameTgm@"

if [[ ${NIX_DEBUG:-0} -gt 6 ]]; then
    set -x
fi

#-------------------------------------------------------------------------------

# https://specifications.freedesktop.org/basedir/latest/
declare -a confDirs=() dataDirs=()

if [[ -v XDG_CONFIG_HOME && -n "$XDG_CONFIG_HOME" ]]; then
    confDirs+=("$XDG_CONFIG_HOME")
elif [[ -v HOME ]]; then
    confDirs+=("$HOME/.config")
fi
IFS=: read -ra cs <<<"${XDG_CONFIG_DIRS:-"/etc/xdg"}"
confDirs+=("${cs[@]}")

if [[ -v XDG_DATA_HOME && -n "$XDG_DATA_HOME" ]]; then
    dataDirs+=("$XDG_DATA_HOME")
elif [[ -v HOME ]]; then
    dataDirs+=("$HOME/.local/share")
fi
IFS=: read -ra ds <<<"${XDG_DATA_DIRS:-"/usr/local/share:/usr/share"}"
dataDirs+=("${ds[@]}")

stateDir="${XDG_STATE_HOME:-"$HOME/.local/state"}"
cacheDir="${XDG_CACHE_HOME:-"${HOME}/.cache"}"

#-------------------------------------------------------------------------------

# $1: dir suffix; $2+: prefixes
function mkSearchPath() {
    local out='' first=true
    for p in "${@:2}"; do
        if [[ "$first" == "false" ]]; then
            echo -n ';'
        else
            first=false
        fi
        echo -n "${p}/${1}"
    done
    echo
}

# name of subdir within XDG dirs
readonly N=mame-tgm

declare -a args=(
    -rompath       "$(mkSearchPath $N/roms      "${dataDirs[@]}");roms"
    -samplepath    "$(mkSearchPath $N/samples   "${dataDirs[@]}");samples"
    -artpath       "$(mkSearchPath $N/artwork   "${dataDirs[@]}");artwork"
    -ctrlrpath     "$(mkSearchPath $N/ctrlr     "${confDirs[@]}");ctrlr"
    -inipath       "$(mkSearchPath $N           "${confDirs[@]}");ini;."
    -fontpath      "$(mkSearchPath $N/fonts     "${dataDirs[@]}");fonts;."
    -cheatpath     "$(mkSearchPath $N/cheat     "${dataDirs[@]}");cheat"
    -crosshairpath "$(mkSearchPath $N/crosshair "${dataDirs[@]}");crosshair"

    -cfg_directory      "${stateDir}/$N/cfg"
    -nvram_directory    "${cacheDir}/$N/nvram"
    -memcard_directory  "${stateDir}/$N/memcard"
    -input_directory    "${cacheDir}/$N/input"
    -state_directory    "${stateDir}/$N/state"
    -snapshot_directory "${stateDir}/$N/snap"
    -diff_directory     "${cacheDir}/$N/diff"
    -comment_directory  "${stateDir}/$N/comments"

    -keymap_file        "${confDirs[0]}/$N/keymap.dat"

    -joy

    # TODO: don't hardcode this?
    -videodriver x11

    @extraArgs@
)

#-------------------------------------------------------------------------------

if [[ ${NIX_DEBUG:-0} -ge 1 ]]; then
    set -x
fi

exec "${MAME_TGM}" "${args[@]}" "${@}"

# todo: look for `-taptracker` in args
