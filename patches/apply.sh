#!/bin/bash

echo 'source+=("1.patch" "2.patch")' >> PKGBUILD

cat >> PKGBUILD << 'EOF'

prepare() {
  cd "$srcdir/PrismLauncher-$pkgver"

  patch -Np1 -i "${srcdir}/1.patch"
  patch -Np1 -i "${srcdir}/2.patch"
}
EOF
