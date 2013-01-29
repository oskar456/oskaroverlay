# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/openssh/openssh-6.0_p1.ebuild,v 1.2 2012/05/03 00:43:39 vapier Exp $

EAPI="2"
inherit eutils flag-o-matic multilib autotools pam systemd

# Make it more portable between straight releases
# and _p? releases.
PARCH=${P/_}

DESCRIPTION="Port of OpenBSD's free SSH release"
HOMEPAGE="http://www.openssh.org/"
SRC_URI="mirror://openbsd/OpenSSH/portable/${PARCH}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE="kerberos libedit pam selinux skey static tcpd X +ldns"

RDEPEND="pam? ( virtual/pam )
	kerberos? ( virtual/krb5 )
	selinux? ( >=sys-libs/libselinux-1.28 )
	skey? ( >=sys-auth/skey-1.1.5-r1 )
	libedit? ( dev-libs/libedit )
	>=dev-libs/openssl-0.9.6d
	>=sys-libs/zlib-1.2.3
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	X? ( x11-apps/xauth )
	userland_GNU? ( virtual/shadow )
	ldns? ( net-libs/ldns )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	virtual/os-headers
	sys-devel/autoconf"
RDEPEND="${RDEPEND}
	pam? ( >=sys-auth/pambase-20081028 )"

S=${WORKDIR}/${PARCH}

save_version() {
	# version.h patch conflict avoidence
	mv version.h version.h.$1
	cp -f version.h.pristine version.h
}

src_prepare() {
	sed -i \
		-e '/_PATH_XAUTH/s:/usr/X11R6/bin/xauth:/usr/bin/xauth:' \
		pathnames.h || die
	# keep this as we need it to avoid the conflict between LPK and HPN changing
	# this file.
	cp version.h version.h.pristine

	# don't break .ssh/authorized_keys2 for fun
	sed -i '/^AuthorizedKeysFile/s:^:#:' sshd_config || die

			epatch "${FILESDIR}"/${P}-sshfp-downgrade.patch
		epatch "${FILESDIR}"/${P}-future-digests.patch
		epatch "${FILESDIR}"/${P}-sshfp-certificate.patch
		epatch "${FILESDIR}"/${P}-ldns-do-not-trust-ad.patch
		epatch "${FILESDIR}"/${P}-hardcode-trust-anchor.patch
		epatch "${FILESDIR}"/${PN}-5.9_p1-sshd-gssapi-multihomed.patch #378361
		epatch "${FILESDIR}"/${PN}-4.7_p1-GSSAPI-dns.patch #165444 integrated into gsskex
		if [[ -n ${HPN_PATCH} ]] && use hpn; then
			epatch "${WORKDIR}"/${HPN_PATCH%.*}
			epatch "${FILESDIR}"/${PN}-6.0_p1-hpn-progressmeter.patch
			save_version HPN
			# The AES-CTR multithreaded variant is broken, and causes random hangs
			# when combined background threading and control sockets. To avoid
			# this, we change the internal table to use the non-multithread version
			# for the meantime. Do NOT remove this in new versions. See bug #354113
			# comment #6 for testcase.
			# Upstream reference: http://www.psc.edu/networking/projects/hpn-ssh/
			## Additionally, the MT-AES-CTR mode cipher replaces the default ST-AES-CTR mode
			## cipher. Be aware that if the client process is forked using the -f command line
			## option the process will hang as the parent thread gets 'divorced' from the key
			## generation threads. This issue will be resolved as soon as possible
			sed -i \
				-e '/aes...-ctr.*SSH_CIPHER_SSH2/s,evp_aes_ctr_mt,evp_aes_128_ctr,' \
				cipher.c || die
		fi

		sed -i "s:-lcrypto:$(pkg-config --libs openssl):" configure{,.ac} || die

		# Disable PATH reset, trust what portage gives us. bug 254615
		sed -i -e 's:^PATH=/:#PATH=/:' configure || die

		# Now we can build a sane merged version.h
		(
			sed '/^#define SSH_RELEASE/d' version.h.* | sort -u
			macros=()
			for p in HPN LPK X509 ; do [ -e version.h.${p} ] && macros+=( SSH_${p} ) ; done
			printf '#define SSH_RELEASE SSH_VERSION SSH_PORTABLE %s\n' "${macros}"
		) > version.h

		eautoreconf
	}

	static_use_with() {
		local flag=$1
	if use static && use ${flag} ; then
		ewarn "Disabling '${flag}' support because of USE='static'"
		# rebuild args so that we invert the first one (USE flag)
		# but otherwise leave everything else working so we can
		# just leverage use_with
		shift
		[[ -z $1 ]] && flag="${flag} ${flag}"
		set -- !${flag} "$@"
	fi
	use_with "$@"
}

src_configure() {
	addwrite /dev/ptmx
	addpredict /etc/skey/skeykeys #skey configure code triggers this

	use static && append-ldflags -static

	econf \
		--with-ldflags="${LDFLAGS}" \
		--disable-strip \
		--sysconfdir=/etc/ssh \
		--libexecdir=/usr/$(get_libdir)/misc \
		--datadir=/usr/share/openssh \
		--with-privsep-path=/var/empty \
		--with-privsep-user=sshd \
		--with-md5-passwords \
		--with-ssl-engine \
		$(static_use_with pam) \
		$(static_use_with kerberos kerberos5 /usr) \
		${LDAP_PATCH:+$(use X509 || ( use ldap && use_with ldap ))} \
		$(use_with libedit) \
		$(use_with selinux) \
		$(use_with skey) \
		$(use_with ldns) \
		$(use_with tcpd tcp-wrappers)
}

src_install() {
	emake install-nokeys DESTDIR="${D}" || die
	fperms 600 /etc/ssh/sshd_config
	dobin contrib/ssh-copy-id || die
	newinitd "${FILESDIR}"/sshd.rc6.3 sshd
	newconfd "${FILESDIR}"/sshd.confd sshd
	keepdir /var/empty

	# not all openssl installs support ecc, or are functional #352645
	if ! grep -q '#define OPENSSL_HAS_ECC 1' config.h ; then
		elog "dev-libs/openssl was built with 'bindist' - disabling ecdsa support"
		dosed 's:&& gen_key ecdsa::' /etc/init.d/sshd || die
	fi

	newpamd "${FILESDIR}"/sshd.pam_include.2 sshd
	if use pam ; then
		sed -i \
			-e "/^#UsePAM /s:.*:UsePAM yes:" \
			-e "/^#PasswordAuthentication /s:.*:PasswordAuthentication no:" \
			-e "/^#PrintMotd /s:.*:PrintMotd no:" \
			-e "/^#PrintLastLog /s:.*:PrintLastLog no:" \
			"${D}"/etc/ssh/sshd_config || die "sed of configuration file failed"
	fi

	# Gentoo tweaks to default config files
	cat <<-EOF >> "${D}"/etc/ssh/sshd_config

	# Allow client to pass locale environment variables #367017
	AcceptEnv LANG LC_*
	EOF
	cat <<-EOF >> "${D}"/etc/ssh/ssh_config

	# Send locale environment variables #367017
	SendEnv LANG LC_*
	EOF

	# This instruction is from the HPN webpage,
	# Used for the server logging functionality
	if [[ -n ${HPN_PATCH} ]] && use hpn ; then
		keepdir /var/empty/dev
	fi

	if use ldap ; then
		insinto /etc/openldap/schema/
		newins openssh-lpk_openldap.schema openssh-lpk.schema
	fi

	doman contrib/ssh-copy-id.1
	dodoc ChangeLog CREDITS OVERVIEW README* TODO sshd_config

	diropts -m 0700
	dodir /etc/skel/.ssh

	systemd_dounit "${FILESDIR}"/sshd.{service,socket} || die
	systemd_newunit "${FILESDIR}"/sshd_at.service 'sshd@.service' || die
}

src_test() {
	local t tests skipped failed passed shell
	tests="interop-tests compat-tests"
	skipped=""
	shell=$(egetshell ${UID})
	if [[ ${shell} == */nologin ]] || [[ ${shell} == */false ]] ; then
		elog "Running the full OpenSSH testsuite"
		elog "requires a usable shell for the 'portage'"
		elog "user, so we will run a subset only."
		skipped="${skipped} tests"
	else
		tests="${tests} tests"
	fi
	# It will also attempt to write to the homedir .ssh
	local sshhome=${T}/homedir
	mkdir -p "${sshhome}"/.ssh
	for t in ${tests} ; do
		# Some tests read from stdin ...
		HOMEDIR="${sshhome}" \
		emake -k -j1 ${t} </dev/null \
			&& passed="${passed}${t} " \
			|| failed="${failed}${t} "
	done
	einfo "Passed tests: ${passed}"
	ewarn "Skipped tests: ${skipped}"
	if [[ -n ${failed} ]] ; then
		ewarn "Failed tests: ${failed}"
		die "Some tests failed: ${failed}"
	else
		einfo "Failed tests: ${failed}"
		return 0
	fi
}

pkg_preinst() {
	enewgroup sshd 22
	enewuser sshd 22 -1 /var/empty sshd
}

pkg_postinst() {
	elog "Starting with openssh-5.8p1, the server will default to a newer key"
	elog "algorithm (ECDSA).  You are encouraged to manually update your stored"
	elog "keys list as servers update theirs.  See ssh-keyscan(1) for more info."
	echo
	ewarn "Remember to merge your config files in /etc/ssh/ and then"
	ewarn "reload sshd: '/etc/init.d/sshd reload'."
	if use pam ; then
		echo
		ewarn "Please be aware users need a valid shell in /etc/passwd"
		ewarn "in order to be allowed to login."
	fi
	if use ldns ; then
		echo
		elog "In order to enable autonomous DNSSEC validation,"
		elog "add a trust anchor record to your resolv.conf:"
		elog " anchor /path/to/root.key"
	fi
}
