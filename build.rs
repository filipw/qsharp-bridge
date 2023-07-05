use uniffi_bindgen::{generate_bindings};

fn main() {
    let udl_file = "./src/swift-qsharp.udl";
    let out_dir = "./bindings/";
    uniffi_build::generate_scaffolding(udl_file).unwrap();
    generate_bindings(udl_file.into(), 
        None, 
        vec!["swift"], 
        Some(out_dir.into()), 
        None, 
        true).unwrap();
}