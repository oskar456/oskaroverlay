# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libnfsidmap/libnfsidmap-0.24.ebuild,v 1.7 2012/05/21 19:13:27 xarthisius Exp $

EAPI="5"

inherit autotools eutils git-2

DESCRIPTION="NFSv4 ID <-> name mapping library"
HOMEPAGE="http://www.citi.umich.edu/projects/nfsv4/linux/"
EGIT_REPO_URI="git://git.linux-nfs.org/projects/steved/libnfsidmap.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="ldap static-libs"

DEPEND="ldap? ( net-nds/openldap )"
RDEPEND="${DEPEND}
	!<net-fs/nfs-utils-1.2.2
	!net-fs/idmapd"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		$(use_enable ldap)
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README

	insinto /etc
	doins idmapd.conf || die

	# remove useless files
	rm -f "${D}"/usr/lib*/libnfsidmap/*.{a,la}
	use static-libs || rm -f "${D}"/usr/lib*/*.la
}
