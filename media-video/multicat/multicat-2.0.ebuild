# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Multicast MPEG-2 Transport Streams swiss army knife."
HOMEPAGE="http://www.videolan.org/projects/multicat.html"
SRC_URI="http://downloads.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=media-video/bitstream-1.0"
RDEPEND=""

src_configure() {
	export PREFIX="${EPREFIX}"/usr
}
