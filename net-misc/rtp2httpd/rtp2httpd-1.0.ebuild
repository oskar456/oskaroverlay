# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Multicast RTP to Unicast HTTP stream convertor"
HOMEPAGE="https://github.com/oskar456/rtp2httpd"
SRC_URI="http://github.com/oskar456/rtp2httpd/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	defaults
	newinitd "${FILESDIR}/rtp2httpd.init" rtp2httpd
}
