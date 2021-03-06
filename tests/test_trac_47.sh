#!/bin/bash

#
# Tests for ticket #47
#

export I2G_MPI_START_ENABLE_TESTING="TEST"
# source the mpi-start code to have all functions
. $I2G_MPI_START
mpi_start_check_options

oneTimeTearDown () {
    for f in $MPI_START_CLEANUP_FILES; do
        [ -f "$f" ] && rm -f $f
        [ -d "$f" ] && rm -rf $f
    done
}


testBug47() {
    export MPI_MPICH_MPIRUN=`$MYMKTEMP`
    cat > $MPI_MPICH_MPIRUN << EOF
#/bin/sh
exit 0
EOF
    chmod +x $MPI_MPICH_MPIRUN

    export I2G_MPI_PRE_RUN_HOOK=`$MYMKTEMP`
    cat > $I2G_MPI_PRE_RUN_HOOK << EOF
#/bin/sh

pre_run_hook () {
    if test "\$MPI_MPIRUN" == "$MPI_MPICH_MPIRUN" ; then
        return 0
    else
        return 1
    fi
}
EOF
    MPI_START_SCHEDULER="pbs"
    MPI_START_DISABLE_LRMS_INTEGRATION="no"
    # load openmpi
    export I2G_MPI_TYPE=mpich
    mpi_start_get_plugin "mpich.mpi" 1
    . $MPI_START_PLUGIN_FILES
    mpi_start
    assertEquals "0" "$?"
    rm -f $MPI_MPICH_MPIRUN $I2G_MPI_PRE_RUN_HOOK
}

. $SHUNIT2

