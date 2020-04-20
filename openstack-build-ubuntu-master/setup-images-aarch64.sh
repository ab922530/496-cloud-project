#!/bin/sh

##
## Download and configure the default aarch64 images.
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

logtstart "images-aarch64"

if [ -f $SETTINGS ]; then
    . $SETTINGS
fi

cd $IMAGEDIR

imgfile=`get_url "http://boss.utah.cloudlab.us/downloads/openstack/xenial-server-cloudimg-arm64-disk1.img https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-arm64-disk1.img"`
imgname=xenial-server
if [ ! $? -eq 0 ]; then
    echo "ERROR: failed to download xenial-server-cloudimg-arm64-disk1.img from Cloudlab or Ubuntu!"
else
    imgfile=`extract_image "$imgfile"`
    if [ ! $? -eq 0 ]; then
	echo "ERROR: failed to extract xenial-server-cloudimg-arm64-disk1.img"
    else
	(fixup_image "$imgfile" \
	    && sched_image "$IMAGEDIR/$imgfile" "$imgname" ) \
	    || echo "ERROR: could not configure default VM image $imgfile !"
    fi
fi

#
# NB: do not exit; we are included!
#

logtend "images-aarch64"
