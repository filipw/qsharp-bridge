HEADERPATH="bindings/qsharp_bridgeFFI.h"
TARGETDIR="target"
OUTDIR="platforms/swift"
RELDIR="release"
NAME="qsharp_bridge"
STATIC_LIB_NAME="lib${NAME}.a"

#rm -f "bindings/qsharp_bridge.swift"
#rm -f "${HEADERPATH}"
#rm -f "bindings/qsharp_bridgeFFI.modulemap"

cargo build --target aarch64-apple-darwin --release
#cargo build --target x86_64-apple-darwin --release
cargo build --target aarch64-apple-ios --release
cargo build --target aarch64-apple-ios-sim --release
#cargo build --target x86_64-apple-ios --release

rm -rf "${OUTDIR}/${NAME}_framework.xcframework"

# rm -rf "${TARGETDIR}/macos-darwin/"
# rm -rf "${TARGETDIR}/ios-simulator/"
# mkdir "${TARGETDIR}/macos-darwin/"
# mkdir "${TARGETDIR}/ios-simulator/"
# mkdir "${TARGETDIR}/macos-darwin/${RELDIR}"
# mkdir "${TARGETDIR}/ios-simulator/${RELDIR}"

#lipo -create -output "${TARGETDIR}/macos-darwin/${RELDIR}/${STATIC_LIB_NAME}" \
#    "${TARGETDIR}/aarch64-apple-darwin/${RELDIR}/${STATIC_LIB_NAME}" 

#lipo -create -output "${TARGETDIR}/ios-simulator/${RELDIR}/${STATIC_LIB_NAME}" \
#    "${TARGETDIR}/aarch64-apple-ios-sim/${RELDIR}/${STATIC_LIB_NAME}" 

xcodebuild -create-xcframework \
    -library "${TARGETDIR}/aarch64-apple-darwin/${RELDIR}/${STATIC_LIB_NAME}" \
    -headers "${HEADERPATH}" \
    -library "${TARGETDIR}/aarch64-apple-ios/${RELDIR}/${STATIC_LIB_NAME}" \
    -headers "${HEADERPATH}" \
    -library "${TARGETDIR}/aarch64-apple-ios-sim/${RELDIR}/${STATIC_LIB_NAME}" \
    -headers "${HEADERPATH}" \
    -output "${OUTDIR}/${NAME}_framework.xcframework"