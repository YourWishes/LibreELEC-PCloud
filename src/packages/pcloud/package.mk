PKG_NAME="pcloud"
PKG_VERSION="2ecb7c9"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/pcloudcom/console-client"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_HOST="boost:host"
PKG_DEPENDS_TARGET="toolchain zlib boost"
PKG_SECTION="libretro"
PKG_SHORTDESC="pCloud"
PKG_LONGDESC="pCloud"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_TOOLCHAIN="make"

make_target() {
  cd $PKG_BUILD/pCloudCC/lib/pclsync/
  make CC="$CC" clean
  make CC="$CC" fs
  cd ../mbedtls/
  cmake .
  make CC="$CC" clean
  make CC="$CC"
  cd ../..

  cmake \
    -DBOOST_ROOT=$(get_build_dir boost) \
	  -DLOCAL_BOOST_DIR=$(get_build_dir boost) \
	  .
  make CC="$CC" clean
  make CC="$CC"
}

makeinstall_target() {
  cp pcloudcc $SYSROOT_PREFIX/usr/bin/pcloudcc
  cp libpcloudcc_lib.so $SYSROOT_PREFIX/usr/lib/libpcloudcc_lib.so
}