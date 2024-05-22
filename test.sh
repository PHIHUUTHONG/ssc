sudo apt install g++-aarch64-linux-gnu binutils-aarch64-linux-gnu
export CROSS_COMPILE=aarch64-linux-gnu-
./ssc -e libandroid-wordexp.so echo.sh kaka.sh
#./ssc -s echo.sh kaka.sh
