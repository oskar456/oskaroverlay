oskaroverlay
============

My personal Gentoo portage overlay

Contains notably patched OpenSSH with proper support to DNSSEC and SSHFP records for ECDSA host keys.

Installation
------------

1. Add this line to layman.cfg:
    https://raw.github.com/oskar456/oskaroverlay/master/oskaroverlay.xml
2. Fetch list of overlays using `layman -f`
3. Run `layman -a oskaroverlay`

