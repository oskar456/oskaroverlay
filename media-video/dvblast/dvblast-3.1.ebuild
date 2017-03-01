# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Simple and powerful MPEG-2/TS demux and streaming application."
HOMEPAGE="http://www.videolan.org/projects/dvblast.html"
SRC_URI="http://downloads.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/bitstream-1.0
	>=sys-kernel/linux-headers-3.1
	dev-libs/libev"
RDEPEND=""

src_configure() {
	export PREFIX="${EPREFIX}"/usr
}

src_install() {
	default
	newinitd "${FILESDIR}/${PN}.init" ${PN}
}
