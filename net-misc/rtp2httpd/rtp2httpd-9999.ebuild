# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools git-2

DESCRIPTION="Multicast RTP to Unicast HTTP stream convertor"
HOMEPAGE="https://github.com/oskar456/rtp2httpd"
EGIT_REPO_URI="https://github.com/oskar456/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_install() {
	default
	newinitd "${FILESDIR}/rtp2httpd.init" rtp2httpd
}
