# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="C headers for a simpler access to MPEG, DVB,... structures."
HOMEPAGE="https://www.videolan.org/developers/bitstream.html"
SRC_URI="https://get.videolan.org/${PN}/${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	export PREFIX="${EPREFIX}"/usr
}
