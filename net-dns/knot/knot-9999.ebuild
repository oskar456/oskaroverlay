# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/knot/knot-1.2.0.ebuild,v 1.1 2013/04/03 17:34:46 scarabeus Exp $

EAPI=5

inherit eutils autotools user git-2

DESCRIPTION="High-performance authoritative-only DNS server"
HOMEPAGE="http://www.knot-dns.cz/"
EGIT_REPO_URI="https://gitlab.labs.nic.cz/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug caps-ng +fastparser"

RDEPEND="
	dev-libs/openssl
	dev-libs/userspace-rcu
	caps-ng? ( sys-libs/libcap-ng )
"
#	sys-libs/glibc
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/flex
	virtual/yacc
	fastparser? ( dev-util/ragel )
"

src_prepare() {
	sed -i \
		-e 's:-Werror::g' \
		configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir="${EPREFIX}/etc/${PN}" \
		--libexecdir="${EPREFIX}/usr/libexec/${PN}" \
		--with-rundir="${EPREFIX}/var/run/${PN}" \
		--disable-lto \
		--enable-recvmmsg \
		$(use_enable fastparser) \
		$(use_enable debug debug server,zones,xfr,packet,dname,rr,ns,hash,compiler) \
		$(use_enable debug debuglevel details)
}

src_install() {
	default

	newinitd "${FILESDIR}/knot.init" knot-dns
}

pkg_postinst() {
	enewgroup knot 53
	enewuser knot 53 -1 /var/lib/knot knot
	if [[ -n ${REPLACING_VERSIONS} ]] ; then
		elog "Remember to recompile all zones after update. Run:"
		elog "    # knotc stop"
		elog "    # knotc compile"
		elog "    # knotd -d"
	fi
}
