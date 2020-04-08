# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools git-r3

DESCRIPTION="Digital PDC/VPS analyzer/recorder"
HOMEPAGE="https://github.com/oskar456/vpsrecord"
EGIT_REPO_URI="https://github.com/oskar456/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/zvbi"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}
