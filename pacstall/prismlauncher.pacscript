# Maintainer: Giovanni Harting <anonfunc@archlinux.org>
# Contributor: Sefa Eyeoglu <contact@scrumplex.net>
# Contributor: txtsd <aur.archlinux@ihavea.quest>
# Contributor: seth <getchoo at tuta dot io>
# Contributor: Lenny McLennington <lennymclennington@protonmail.com>
# Contributor: Elijah Gregg <lovetocode999@tilde.team>
# Contributor: Miko <mikoxyzzz@gmail.com>
# Contributor: Cheru Berhanu <aur attt cheru doot dev>
# Contributor: dada513 <dada513@protonmail.com>

pkgname=prismlauncher
pkgver=10.0.2
pkgrel=1
pkgdesc="Minecraft launcher with ability to manage multiple instances"
arch=(x86_64)
url='https://prismlauncher.org'
license=('GPL-3.0-only' 'LGPL-3.0-or-later' 'LGPL-2.0-or-later' 'Apache-2.0' 'MIT' 'OFL-1.1')
depends=(
  libc6
  mesa-utils
  libgcc-s1
  default-jre
  libarchive13
  libgl1
  pciutils
  libqrencode4
  qt6-base-dev
  qt6-image-formats-plugins
  qt6-networkauth-dev
  qt6-svg-dev
  zlib1g
  hicolor-icon-theme
  libtomlplusplus3
  libcmark0.30.2
)
makedepends=(cmake extra-cmake-modules git openjdk-17-jdk ninja-build scdoc gamemode-dev)
optdepends=('libglfw3: to use system GLFW libraries'
            'libopenal1: to use system OpenAL libraries'
            'visualvm: Profiling support'
            'x11-xserver-utils: for older minecraft versions'
            'orca: minecraft screen reader'
            'flite: minecraft voice narration')
source=("https://github.com/PrismLauncher/PrismLauncher/releases/download/$pkgver/PrismLauncher-$pkgver.tar.gz"
        {lionshead,batch,mdi}.license
        {1,2}.patch)
b2sums=('401ff4f32d74685b41219397b4a437f7c5c27417b01aa61463253be8e7e637f0502f0be3b22c387facfbb320a7923703ad8a91572e12738740cc9dd66aa90385'
        'be4289832af95b1cd6e721dc16b84a034533de9718d9b43a49bd08dd6fe4e28eaa15228bfb311867b18fddbda1c9fc4c91f04c6d5c1a3bcc39aaa5161425e3ba'
        '356248a6b86f06d260e0920b49d34034f79f9bc504c7fdc1849d929d2ff9b169e693a8269a2c0b34656b3802970d9b8be41a92b35177eaa3c4ccc89a702f5c9d'
        'b35c447cd9223e096a2bb75e0741a7d0a3a1606af54c957e4f276f4e6861a9b3f06ae1d646137e8d2f24ba2238c9967c76eff8cc631a68d7e48e376056982cc6'
        'SKIP' 'SKIP')

prepare() {
  cd PrismLauncher-$pkgver

  patch -Np1 -i $srcdir/1.patch
  patch -Np1 -i $srcdir/2.patch
}

build() {
  cd PrismLauncher-$pkgver

  export PATH="/usr/lib/jvm/java-17-openjdk/bin/:$PATH"

  cmake -DCMAKE_BUILD_TYPE= \
    -GNinja \
    -DCMAKE_INSTALL_PREFIX="/usr" \
    -DLauncher_BUILD_PLATFORM="archlinux" \
    -DLauncher_QT_VERSION_MAJOR="6" \
    -DLauncher_ENABLE_JAVA_DOWNLOADER=ON \
    -DCMAKE_C_FLAGS="$CFLAGS -DNDEBUG" \
    -DCMAKE_CXX_FLAGS="$CXXFLAGS -DNDEBUG" \
    -Bbuild -S.
  cmake --build build
}

check() {
  cd PrismLauncher-$pkgver/build
  ctest .
}

package() {
  # licenses
  install -Dm644 lionshead.license -t "$pkgdir"/usr/share/licenses/$pkgname/
  install -Dm644 batch.license -t "$pkgdir"/usr/share/licenses/$pkgname/
  install -Dm644 mdi.license -t "$pkgdir"/usr/share/licenses/$pkgname/

  cd PrismLauncher-$pkgver/build
  DESTDIR="$pkgdir" cmake --install .
}

# vim:set ts=2 sw=2 et:
