# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Digital PDC/VPS analyzer/recorder"
HOMEPAGE="http://k5.sh.cvut.cz/~oskar/blog/comments.php?y=10&m=03&entry=entry100321-191554"
SRC_URI="http://k5.sh.cvut.cz/~oskar/stah/vpsrecord-1.1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/zvbi"
RDEPEND="${DEPEND}"


src_install() {
	dobin vpsrecord
}
