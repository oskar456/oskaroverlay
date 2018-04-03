# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Multicast MPEG-2 Transport Streams swiss army knife."
HOMEPAGE="https://www.videolan.org/projects/multicat.html"
SRC_URI="https://get.videolan.org/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/bitstream-1.3"
RDEPEND=""

src_configure() {
	export PREFIX="${EPREFIX}"/usr
}

src_install() {
	default
	newinitd "${FILESDIR}/multicat.init" multicat
}
