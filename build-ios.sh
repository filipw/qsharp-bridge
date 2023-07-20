HEADERPATH="bindings/qsharp_bridgeFFI.h"
TARGETDIR="target"
OUTDIR="platforms/swift"
RELDIR="release"
NAME="qsharp_bridge"
STATIC_LIB_NAME="lib${NAME}.a"

cargo build --target aarch64-apple-darwin --release
cargo build --target aarch64-apple-ios --release
cargo build --target aarch64-apple-ios-sim --release

rm -rf "${OUTDIR}/${NAME}_framework.xcframework"

xcodebuild -create-xcframework \
    -library "${TARGETDIR}/aarch64-apple-darwin/${RELDIR}/${STATIC_LIB_NAME}" \
    -headers "${HEADERPATH}" \
    -library "${TARGETDIR}/aarch64-apple-ios/${RELDIR}/${STATIC_LIB_NAME}" \
    -headers "${HEADERPATH}" \
    -library "${TARGETDIR}/aarch64-apple-ios-sim/${RELDIR}/${STATIC_LIB_NAME}" \
    -headers "${HEADERPATH}" \
    -output "${OUTDIR}/${NAME}_framework.xcframework"