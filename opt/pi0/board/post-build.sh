#!/bin/sh

set -u
set -e

# Clean up files included in skeleton not needed
rm -f ${TARGET_DIR}/etc/init.d/S01syslogd
rm -f ${TARGET_DIR}/etc/init.d/S02klogd
rm -f ${TARGET_DIR}/etc/init.d/S02sysctl
rm -f ${TARGET_DIR}/etc/init.d/S02mdev
rm -f ${TARGET_DIR}/etc/init.d/S20seedrng
rm -f ${TARGET_DIR}/etc/init.d/S40network
rm -f ${TARGET_DIR}/etc/init.d/S50pigpio

# Clean up test files included with numpy
rm -rf ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/tests
rm -rf ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/testing
rm -rf ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/core/tests
rm -rf ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/linalg/tests
rm -rf ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/f2py/tests
rm -rf ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/typing/tests

# Clean up files included in embit we don't need
rm -rf ${TARGET_DIR}/usr/lib/python3.10/site-packages/embit/liquid
rm -rf ${TARGET_DIR}/usr/lib/python3.10/site-packages/embit/util/prebuilt/libsecp256k1_darwin_arm64.dylib
rm -rf ${TARGET_DIR}/usr/lib/python3.10/site-packages/embit/util/prebuilt/libsecp256k1_darwin_x86_64.dylib
rm -rf ${TARGET_DIR}/usr/lib/python3.10/site-packages/embit/util/prebuilt/libsecp256k1_linux_aarch64.so
rm -rf ${TARGET_DIR}/usr/lib/python3.10/site-packages/embit/util/prebuilt/libsecp256k1_linux_x86_64.so
rm -rf ${TARGET_DIR}/usr/lib/python3.10/site-packages/embit/util/prebuilt/libsecp256k1_windows_amd64.dll

# Clean up tests/docs in other python included libs
rm -rf ${TARGET_DIR}/usr/lib/python3.10/site-packages/pyzbar/tests
rm -rf ${TARGET_DIR}/usr/lib/python3.10/site-packages/qrcode/tests

# Clean up bigger python modules we don't need
rm -rf ${TARGET_DIR}/usr/lib/python3.10/turtle.pyc
rm -rf ${TARGET_DIR}/usr/lib/python3.10/pydoc.pyc
rm -rf ${TARGET_DIR}/usr/lib/python3.10/doctest.pyc
rm -rf ${TARGET_DIR}/usr/lib/python3.10/mailbox.pyc
rm -rf ${TARGET_DIR}/usr/lib/python3.10/zipfile.pyc
rm -rf ${TARGET_DIR}/usr/lib/python3.10/tarfile.pyc
rm -rf ${TARGET_DIR}/usr/lib/python3.10/pickletools.pyc
rm -rf ${TARGET_DIR}/usr/lib/python3.10/turtledemo
rm -rf ${TARGET_DIR}/usr/lib/python3.10/unittest
rm -rf ${TARGET_DIR}/usr/lib/python3.10/ensurepip

# ### Reproducibility experimentation
# ### Remove all pyc files I can seem to make reproducible and keep the py versions

rm -f ${TARGET_DIR}/usr/lib/python3.10/config-3.10-arm-linux-gnueabihf/Makefile
rm -f ${TARGET_DIR}/usr/lib/python3.10/multiprocessing/connection.pyc
rm -f ${TARGET_DIR}/usr/lib/python3.10/json/decoder.pyc
rm -f ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/core/_string_helpers.pyc
rm -f ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/distutils/ccompiler.pyc
rm -f ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/distutils/command/build_py.pyc
rm -f ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/distutils/misc_util.pyc
rm -f ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/distutils/system_info.pyc
rm -f ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/f2py/auxfuncs.pyc
rm -f ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/f2py/crackfortran.pyc
rm -f ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/f2py/f2py2e.pyc
rm -f ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/lib/_iotools.pyc
rm -f ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/lib/npyio.pyc
rm -f ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/lib/recfunctions.pyc
rm -f ${TARGET_DIR}/usr/lib/python3.10/site-packages/numpy/lib/stride_tricks.pyc
rm -f ${TARGET_DIR}/usr/lib/python3.10/traceback.pyc
rm -f ${TARGET_DIR}/usr/lib/python3.10/_sysconfigdata__linux_arm-linux-gnueabihf.pyc

find ${TARGET_DIR}/usr/lib/python3.10 -name '*.py' \
	-not -path "*/python3.10/multiprocessing/connection.py" \
	-not -path "*/python3.10/json/decoder.py" \
	-not -path "*/python3.10/site-packages/numpy/core/_string_helpers.py" \
	-not -path "*/python3.10/site-packages/numpy/distutils/ccompiler.py" \
	-not -path "*/python3.10/site-packages/numpy/distutils/command/build_py.py" \
	-not -path "*/python3.10/site-packages/numpy/distutils/misc_util.py" \
	-not -path "*/python3.10/site-packages/numpy/distutils/system_info.py" \
	-not -path "*/python3.10/site-packages/numpy/f2py/auxfuncs.py" \
	-not -path "*/python3.10/site-packages/numpy/f2py/crackfortran.py" \
	-not -path "*/python3.10/site-packages/numpy/f2py/f2py2e.py" \
	-not -path "*/python3.10/site-packages/numpy/lib/_iotools.py" \
	-not -path "*/python3.10/site-packages/numpy/lib/npyio.py" \
	-not -path "*/python3.10/site-packages/numpy/lib/recfunctions.py" \
	-not -path "*/python3.10/site-packages/numpy/lib/stride_tricks.py" \
	-not -path "*/python3.10/traceback.py" \
	-not -path "*/python3.10/_sysconfigdata__linux_arm-linux-gnueabihf.py" \
	-print0 | \
	xargs -0 --no-run-if-empty rm -f

find "${TARGET_DIR}" -name '.DS_Store' -print0 | xargs -0 --no-run-if-empty rm -f

# Add python byte code (aka __pycache__ directories) to increase boot and import module speed
SOURCE_DATE_EPOCH=1 PYTHONHASHSEED=0 ${HOST_DIR}/bin/python3.10 \
  "${BUILD_DIR}/python3-3.10.10/Lib/compileall.py" \
  -f --invalidation-mode=checked-hash "${TARGET_DIR}/opt/src"

echo "/usr/sbin/rngd -r /dev/hwrng" > ${TARGET_DIR}/etc/init.d/S99rngd
chmod +x ${TARGET_DIR}/etc/init.d/S99rngd