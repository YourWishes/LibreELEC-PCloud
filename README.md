# LibreELEC-pCloud
Module that was created by me to allow me to have pCloudCC Support within Lakka.
Haven't tested with LibreELEC but I imagine it will work the same.

Tested on a Raspberry Pi 4B 8GB.


# Setup
Clone your LibreELEC based O.S., I will be using [Lakka](https://github.com/libretro/Lakka-LibreELEC).
Start by compiling your O.S. once to ensure no errors and to speed up future
compiles. Then copy the contents of `src` from *this* repository into your O.S.

# Modify Packages
You will need to modify two packages to compile correctly, *Boost* and your O.S.
root .mk package.

Start with Boost, we need to include some extra flags with our compile, and an
additional compile command to stage things. Start by navigating to
`packages/devel/boost/package.mk`

Under the `configure_target()` method, find the lines that read;
```
--with-python=$SYSROOT_PREFIX/bin/python \
```
And add the following line after it;
```
--with-libraries=system,program_options \
```

Then find the `makeinstall_target()` method, and find the end of the method, and insert the following;
```
  $TOOLCHAIN/bin/bjam -d2 --ignore-site-config \
                          --layout=system \
                          --prefix=$SYSROOT_PREFIX/usr \
                          --toolset=gcc link=static \
                          --with-chrono \
                          --with-date_time \
                          --with-filesystem \
                          --with-iostreams \
                          --with-python \
                          --with-random \
                          --with-regex -sICU_PATH="$SYSROOT_PREFIX/usr" \
                          --with-serialization \
                          --with-system \
                          --with-thread \
                          stage
```
Then save the file.

Now modify your OS's root package.mk file to include an additional dependency.
For Lakka this is located in `packages/libretro/retroarch/package.mk`, for other
operating systems you may need to find this yourself.

Find the line that starts with `PKG_DEPENDS_TARGET="` and add the following just before the closing quote mark; ` pcloud` ensuring there is a space before the word.

# Recompiling
First we need to cleanup boost and make sure it's compiling, start by setting
your environment variables such as `DISTRO`, `DEVICE` and `ARCH` as you would
normally, then run `scripts/clean boost` at the end and then run `scripts/build pcloud`
to compile boost, then pcloud.

Monitor the output for any errors.

# Installing
After pCloudCC compiles then build and image your O.S. as normal, alternatively
you can simply upload the `pcloudcc` bin and `libpcloudcc_lib.so` library from
`build*/pcloud-*/pCloudCC/` directory. This is how I do it to avoid me having
to reimage my entire O.S. I store my output in `/storage/.pcloud/`

You need to run pcloud once to login, you can do this running the command;
```
./pcloudcc -u [your email] -s -p
```
pCloud will ask for your password and store it securely. Afterwards you can see
this running in the `/storage/pCloudDrive/` directory.

With LibreELEC you can have a process run on bootup by adding it to `/storage/.config/autostart.sh`, ensuring that you have `chmod +x` supported it.

I add the following lines to my autostart.sh to execute on bootup
```
EMAIL="Your email"
cd /storage/.pcloud/
./pcloudcc -u $EMAIL &
```
If you are stuck at the bootup screen after doing so, ensure you haven't omitted the `&`