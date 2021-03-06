# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libevent/libevent-2.1.1.ebuild,v 1.5 2012/10/15 11:47:19 jer Exp $

EAPI=4
inherit eutils libtool

MY_P="${P}-alpha"

DESCRIPTION="A library to execute a function when a specific event occurs on a file descriptor"
HOMEPAGE="http://monkey.org/~provos/libevent/"
SRC_URI="mirror://sourceforge/levent/files/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+ssl static-libs test"

DEPEND="ssl? ( dev-libs/openssl )"
RDEPEND="
	${DEPEND}
	!<=dev-libs/9libs-1.0
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	elibtoolize

	# don't waste time building tests/samples
	sed -i \
		-e 's|^\(SUBDIRS =.*\)sample test\(.*\)$|\1\2|' \
		Makefile.in || die "sed Makefile.in failed"
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable ssl openssl)
}

src_test() {
	# The test suite doesn't quite work (see bug #406801 for the latest
	# installment in a riveting series of reports).
	:
	# emake -C test check | tee "${T}"/tests
}

DOCS="README ChangeLog*"

src_install() {
	default
	if ! use static-libs; then
		rm -f "${D}"/usr/lib*/libevent*.la
	fi
}
