# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2

DESCRIPTION="Simple and powerful MPEG-2/TS demux and streaming application."
HOMEPAGE="http://www.videolan.org/projects/dvblast.html"
EGIT_REPO_URI="https://code.videolan.org/videolan/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
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
