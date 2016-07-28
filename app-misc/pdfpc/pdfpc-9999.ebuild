# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VALA_MIN_API_VERSION="0.26"
VALA_MAX_API_VERSION="0.30" # fix sed line if you increase this

inherit vala cmake-utils git-2

DESCRIPTION="Presenter console with multi-monitor support for PDF files"
HOMEPAGE="http://pdfpc.github.io"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="app-text/poppler:=[cairo]
	dev-libs/glib:2
	dev-libs/libgee:0.8
	gnome-base/librsvg
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	sys-apps/dbus
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	$(vala_depend)"

src_prepare() {
	sed -i -e "s/valac-0.20/valac-0.30 valac-0.28 valac-0.26/" cmake/vala/FindVala.cmake || die
	vala_src_prepare
}

src_configure(){
	local mycmakeargs=(
		-DSYSCONFDIR="${EPREFIX}/etc"
	)
	cmake-utils_src_configure
}
