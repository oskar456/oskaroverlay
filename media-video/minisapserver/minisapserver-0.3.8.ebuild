# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Simple Session Annnouncement Protocol server"
HOMEPAGE="http://www.videolan.org"
SRC_URI="http://download.videolan.org/pub/videolan/miniSAPserver/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	default
	newinitd "${FILESDIR}/sapserver.init" sapserver
}
