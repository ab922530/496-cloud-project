#!/bin/sh

##
## Download and configure the default x86_64 images.
##

set -x

DIRNAME=`dirname $0`

# Gotta know the rules!
if [ $EUID -ne 0 ] ; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Grab our libs
. "$DIRNAME/setup-lib.sh"

if [ "$HOSTNAME" != "$CONTROLLER" ]; then
    exit 0;
fi

logtstart "images-x86_64"

if [ -f $SETTINGS ]; then
    . $SETTINGS
fi

cd $IMAGEDIR

echo "*** Configuring a trusty-server x86_64 image ..."
imgfile=bionic-server-cloudimg-ppc64el.img
imgname=bionic-server
#
# First try the local boss, then Apt, then just grab from Ubuntu.
#
imgfile=`get_url "http://boss.${OURDOMAIN}/downloads/openstack/$imgfile https://cloud-images.ubuntu.com/bionic/current/$imgfile"`
if [ ! $? -eq 0 ]; then
    echo "ERROR: failed to download $imgfile from Cloudlab or Ubuntu!"
else
    old="$imgfile"
    imgfile=`extract_image "$imgfile"`
    if [ ! $? -eq 0 ]; then
	echo "ERROR: failed to extract $old"
    else
	(fixup_image "$imgfile" \
	    && sched_image "$IMAGEDIR/$imgfile" "$imgname" ) \
	    || echo "ERROR: could not configure default VM image $imgfile !"
    fi
fi

#
# NB: do not exit; we are included!
#

logtend "images-ppc64le"
