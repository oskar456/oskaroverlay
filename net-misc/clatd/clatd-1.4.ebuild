# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="A 464XLAT CLAT implementation for Linux"
HOMEPAGE="https://github.com/toreanderson/clatd"
SRC_URI="http://github.com/toreanderson/clatd/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-perl/Net-DNS
	dev-perl/IO-Socket-INET6
	dev-perl/Net-IP
	net-proxy/tayga
"

src_compile() {
	pod2man --name clatd --center "clatd - a CLAT implementation for Linux" --section 8 README.pod clatd.8
}

src_install() {
	dosbin clatd
	doman clatd.8
}
