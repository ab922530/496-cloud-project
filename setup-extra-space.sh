
##
## Setup extra space.  We prefer the LVM route, using all available PVs
## to create a big openstack-volumes VG.  If that's not available, we
## fall back to mkextrafs.pl to create whatever it can in /storage.
##

set -x

EUID=`id -u`
# Gotta know the rules!
if [ $EUID -ne 0 ] ; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Grab our libs
. "`dirname $0`/setup-lib.sh"

if [ -f $OURDIR/extra-space-done ]; then
    exit 0
fi

logtstart "extra-space"

if [ -f $SETTINGS ]; then
    . $SETTINGS
fi
if [ -f $LOCALSETTINGS ]; then
    . $LOCALSETTINGS
fi

STORAGEDIR=/storage
VGNAME="openstack-volumes"
ARCH=`uname -m`

maybe_install_packages lvm2
if [ $OSVERSION -ge $OSOCATA ]; then
    maybe_install_packages thin-provisioning-tools
fi

#
# First try to make LVM volumes; fall back to mkextrafs.pl /storage.  We
# use /storage later, so we make the dir either way.
#
mkdir -p ${STORAGEDIR}
echo "STORAGEDIR=${STORAGEDIR}" >> $LOCALSETTINGS
# Check to see if we already have an `emulab` VG.  This would occur
# if the user requested a temp dataset.  If this happens, we simple
# rename it to the VG name we expect.
vgdisplay emulab
if [ $? -eq 0 ]; then
    vgrename emulab $VGNAME
    sed -i -re "s/^(.*)(\/dev\/emulab)(.*)$/\1\/dev\/$VGNAME\3/" /etc/fstab
    LVM=1
    echo "VGNAME=${VGNAME}" >> $LOCALSETTINGS
    echo "LVM=1" >> $LOCALSETTINGS
elif [ -z "$LVM" ] ; then
    LVM=1
    DONE=0

    #
    # Handle unexpected partition layouts (e.g. no 4th partition on boot
    # disk), and setup mkextrafs args, even if we're not going to use
    # it.
    #
    MKEXTRAFS_ARGS="-l -v ${VGNAME} -m util -z 1024"
    # On Cloudlab ARM machines, there is no second disk nor extra disk space
    # Well, now there's a new partition layout; try it.
    if [ "$ARCH" = "aarch64" -o "$ARCH" = "ppc64le" ]; then
	maybe_install_packages gdisk
	sgdisk -i 1 /dev/sda
	if [ $? -eq 0 ] ; then
	    nparts=`sgdisk -p /dev/sda | grep -E '^ +[0-9]+ +.*$' | wc -l`
	    if [ $nparts -lt 4 ]; then
		newpart=`expr $nparts + 1`
		sgdisk -N $newpart /dev/sda
		partprobe /dev/sda
		if [ $? -eq 0 ] ; then
		    partprobe /dev/sda
		    # Add the new partition specifically
		    MKEXTRAFS_ARGS="${MKEXTRAFS_ARGS} -s $newpart"
		fi
	    fi
	fi
    fi

    #
    # See if we can try to use an LVM instead of just the 4th partition.
    #
    lsblk -n -P -b -o NAME,FSTYPE,MOUNTPOINT,PARTTYPE,PARTUUID,TYPE,PKNAME,SIZE | perl -e 'my %devs = (); while (<STDIN>) { $_ =~ s/([A-Z0-9a-z]+=)/;\$$1/g; eval "$_"; if (!($TYPE eq "disk" || $TYPE eq "part")) { next; }; if (exists($devs{$PKNAME})) { delete $devs{$PKNAME}; } if ($FSTYPE eq "" && $MOUNTPOINT eq "" && ($PARTTYPE eq "" || $PARTTYPE eq "0x0") && (int($SIZE) > 3221225472)) { $devs{$NAME} = "/dev/$NAME"; } }; print join(" ",values(%devs))."\n"' > /tmp/devs
    DEVS=`cat /tmp/devs`
    if [ -n "$DEVS" ]; then
	pvcreate $DEVS && vgcreate $VGNAME $DEVS
	if [ ! $? -eq 0 ]; then
	    echo "ERROR: failed to create PV/VG with '$DEVS'; falling back to mkextrafs.pl"
	    vgremove $VGNAME
	    pvremove $DEVS
	    DONE=0
	else
	    DONE=1
	fi
    fi

    if [ $DONE -eq 0 ]; then
	/usr/local/etc/emulab/mkextrafs.pl ${MKEXTRAFS_ARGS}
	if [ $? -ne 0 ]; then
	    /usr/local/etc/emulab/mkextrafs.pl ${MKEXTRAFS_ARGS} -f
	    if [ $? -ne 0 ]; then
		/usr/local/etc/emulab/mkextrafs.pl -f ${STORAGEDIR}
		LVM=0
	    fi
	fi
    fi

    # Get integer total space (G) available.
    VGTOTAL=`vgs -o vg_size --noheadings --units G $VGNAME | sed -ne 's/ *\([0-9]*\)[0-9\.]*G/\1/p'`
    echo "VGNAME=${VGNAME}" >> $LOCALSETTINGS
    echo "VGTOTAL=${VGTOTAL}" >> $LOCALSETTINGS
    echo "LVM=${LVM}" >> $LOCALSETTINGS
fi

#
# If using LVM, recalculate GLANCE_LV_SIZE, SWIFT_LV_SIZE, and
# CINDER_LV_SIZE.  User gets to specify first two, and we must allocate
# 2x of the swift pools.  If
#   ($VGTOTAL - 1 - GLANCE_LV_SIZE - SWIFT_LV_SIZE * 2) < 20
# we reset SWIFT_LV_SIZE to 4GB; if GLANCE_LV_SIZE == default (32G),
# set that to 0, else set it to 70%free; then set cinder to 15%free.
# Not ideal, but we have to do something other than fail.
#
if [ $LVM -eq 1 ]; then
    vgt=`expr $VGTOTAL - 1`

    if [ "$HOSTNAME" = "$OBJECTHOST" ]; then
	vgt=`expr $vgt - $SWIFT_LV_SIZE \* 2`
    fi
    if [ "$HOSTNAME" = "$CONTROLLER" ]; then
	vgt=`expr $vgt - $GLANCE_LV_SIZE`
    fi
    if [ $vgt -lt 20 ]; then
	if [ "$HOSTNAME" = "$OBJECTHOST" ]; then
	    SWIFT_LV_SIZE=4
	    vgt=`expr $vgt - $SWIFT_LV_SIZE \* 2`
	fi
	if [ "$HOSTNAME" = "$CONTROLLER" ]; then
	    if [ $GLANCE_LV_SIZE -eq 32 ]; then
		GLANCE_LV_SIZE=0
		CINDER_LV_SIZE=`perl -e "print 0.85 * $vgt;"`
	    else
		GLANCE_LV_SIZE=`perl -e "print 0.70 * $vgt;"`
		CINDER_LV_SIZE=`perl -e "print 0.15 * $vgt;"`
	    fi
	else
	    CINDER_LV_SIZE=`perl -e "print 0.85 * $vgt;"`
	fi
    else
	CINDER_LV_SIZE=`perl -e "print 0.75 * $vgt;"`
    fi
    echo "SWIFT_LV_SIZE=${SWIFT_LV_SIZE}" >> $LOCALSETTINGS
    echo "GLANCE_LV_SIZE=${GLANCE_LV_SIZE}" >> $LOCALSETTINGS
    echo "CINDER_LV_SIZE=${CINDER_LV_SIZE}" >> $LOCALSETTINGS
fi

logtend "extra-space"
touch $OURDIR/extra-space-done
