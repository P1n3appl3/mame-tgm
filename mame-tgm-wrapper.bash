#!@runtimeShell@

set -euo pipefail

readonly MAME_TGM="@mameTgm@"
readonly SPONGE="@sponge@"

if [[ ${NIX_DEBUG:-0} -gt 6 ]]; then
    set -x
fi

# name of subdir within XDG dirs
readonly N=mame-tgm

#-------------------------------------------------------------------------------

if which systemd-path &>/dev/null; then
    confDir=$(systemd-path user-configuration)/$N
    dataDir=$(systemd-path user-shared)/$N
else
    confDir=$HOME/.config/$N
    dataDir=$HOME/.local/share/$N
fi

mkdir -p $confDir
mkdir -p $dataDir/roms

ini="$confDir"/mame.ini
if [ ! -f $ini ]; then
    pushd $confDir
    $MAME_TGM -cc
    sed -n '/^# CORE STATE\/PLAYBACK OPTIONS$/,$p' "$ini" | $SPONGE "$ini"
    popd
fi

#-------------------------------------------------------------------------------

declare -a args=(
    -ctrlrpath     "$confDir/ctrlr;ctrlr"
    -inipath       "$confDir/ini;ini;."
    -rompath       "$dataDir/roms;roms"
    -samplepath    "$dataDir/samples;samples"
    -artpath       "$dataDir/artwork;artwork"
    -fontpath      "$dataDir/fonts;fonts;."
    -cheatpath     "$dataDir/cheat;cheat"
    -crosshairpath "$dataDir/crosshair;crosshair"

    -cfg_directory      "$dataDir/cfg"
    -nvram_directory    "$dataDir/nvram"
    -memcard_directory  "$dataDir/memcard"
    -input_directory    "$dataDir/input"
    -state_directory    "$dataDir/state"
    -snapshot_directory "$dataDir/snap"
    -diff_directory     "$dataDir/diff"
    -comment_directory  "$dataDir/comments"

    -keymap_file        "$confDir/keymap.dat"

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
