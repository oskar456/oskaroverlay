# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools git-r3

DESCRIPTION="Next generation RTP dump"
HOMEPAGE="https://github.com/oskar456/dumprtp6"
EGIT_REPO_URI="https://github.com/oskar456/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

src_prepare() {
	eautoreconf
}
