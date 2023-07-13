use std::process::ExitCode;
use thiserror::Error;
use num_bigint::BigUint;
use num_complex::Complex64;
use qsc::interpret::output::Receiver;
use qsc::interpret::{stateless, output, Value};
use qsc::{PackageStore, SourceMap, hir::PackageId};
use qsc::compile::{compile};

#[derive(Error, Debug)]
pub enum QsError {
    #[error("Error with message: `{error_text}`")]
    ErrorMessage { error_text: String }
}

fn compile_qs(source: &str) -> () {
    let store = PackageStore::new(qsc::compile::core());
    let dependencies: Vec<PackageId> = Vec::new();

    let sources = SourceMap::new(vec![("temp.qs".into(), source.into())], Some("".into()));
    let (unit, errors) = compile(&store, &dependencies, sources);

    if errors.is_empty() {
        ()
    } else {
        for error in errors {
            if let Some(source) = unit.sources.find_by_diagnostic(&error) {
                eprintln!("{:?}", source.clone());
            } else {
                eprintln!("{:?}", error);
            }
        }

        ()
    }
}

fn run_qs(source: &str) -> Result<(), QsError> {
    let source_map = SourceMap::new(vec![("temp.qs".into(), source.into())], Some("".into()));

    let context = match stateless::Context::new(true, source_map) {
        Ok(context) => context,
        Err(errors) => {
            for error in errors {
                eprintln!("error: {:?}", error);
            }
            return Ok(());
        }
    };
    return print_exec_result(context.eval(&mut TerminalReceiver));
}

fn print_exec_result(result: Result<Value, Vec<stateless::Error>>) -> Result<(), QsError> {
    match result {
        Ok(value) => {
            println!("{value}");
            return Ok(());
        }
        Err(errors) => {
            for error in errors {
                if let Some(stack_trace) = error.stack_trace() {
                    eprintln!("{stack_trace}");
                }
                eprintln!("error: {error:?}");
            }
            return Err(QsError::ErrorMessage { error_text: "error".to_string() });
        }
    }
}

struct TerminalReceiver;

impl Receiver for TerminalReceiver {
    fn state(
        &mut self,
        states: Vec<(BigUint, Complex64)>,
        qubit_count: usize,
    ) -> Result<(), output::Error> {
        println!("DumpMachine:");
        for (qubit, amplitude) in states {
            let id = output::format_state_id(&qubit, qubit_count);
            println!("{id}: [{}, {}]", amplitude.re, amplitude.im);
        }

        Ok(())
    }

    fn message(&mut self, msg: &str) -> Result<(), output::Error> {
        println!("{msg}");
        Ok(())
    }
}

#[test]
fn test_run() {
    let source = "
    namespace MyQuantumApp {
        @EntryPoint()
        operation Main() : Unit {
            Message(\"Hello\");
        }
    }";
    let _ = run_qs(source);
}
