#!/bin/bash
# pre-compile some standard Extempore libraries for faster loading

case $(uname) in
    Linux) SHLIB_EXT=so PLATFORM=linux ;;
    Darwin) SHLIB_EXT=dylib PLATFORM=osx ;;
    *) echo Cannot precompile modules for OS:  $(uname) >&2 ; exit 1 ;;
esac

if [ -z "$EXT_LLVM_DIR" ] && [ ! -d "/usr/local/Cellar/extempore-llvm/3.4.1" ] ; then
    echo -e "\033[0;31mError\033[0;00m: You need to set the \033[0;32mEXT_LLVM_DIR\033[0;00m environment variable to point to your (Extempore) LLVM directory."
    exit 2
fi

# this is the 'standard' library
# to override this list, call this script with:
# PRECOMP_LIBS="core/foo.xtm external/bar.xtm" ./compile-stdlib.sh
: ${PRECOMP_LIBS:="\
core/std.xtm \
core/math.xtm \
core/audio_dsp.xtm \
core/instruments.xtm \
external/fft.xtm \
external/sndfile.xtm \
external/audio_dsp_ext.xtm \
external/instruments_ext.xtm \
external/rtmidi.xtm \
external/glib.xtm \
external/gl2.xtm \
external/soil.xtm \
external/shaders.xtm \
external/assimp.xtm \
external/openvg.xtm"}

PRECOMP_COMMAND_FILENAME="xtmprecomp-command-file.xtm"
PRECOMP_EXTEMPORE_RUN_COMMAND="./extempore --nostd --run "

# clear the log file (if present)
rm -f compile-stdlib.log

echo Precompiling the Extempore standard library.  This may take several minutes...
echo

# check all the required shared libs are there
for f in $PRECOMP_LIBS
do
    echo "(sys:precomp:compile-xtm-file \"libs/$f\" #t #t #t)" > $PRECOMP_COMMAND_FILENAME
    echo "Precompiling libs/$f"
    $PRECOMP_EXTEMPORE_RUN_COMMAND $PRECOMP_COMMAND_FILENAME | tee -a compile-stdlib.log
    rc=$?
    if [[ $rc != 0 ]] ; then
        echo -e "\033[0;31mError precompiling libs/$f\033[0;00m"
        echo
        exit $rc
    else
        echo -e "\033[0;32mSuccessfully precompiled libs/$f\033[0;00m"
        echo
    fi
done

rm $PRECOMP_COMMAND_FILENAME

exit 0
