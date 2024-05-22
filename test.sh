sudo apt install g++-aarch64-linux-gnu binutils-aarch64-linux-gnu
export CROSS_COMPILE=aarch64-linux-gnu-
export SSC_INTERPRETER_PATH=/system/bin/sh
export SSC_EXECUTABLE_PATH=/system/bin/sh
./ssc echo.sh kaka.sh
#./ssc -s echo.sh kaka.sh
