uniffi::include_scaffolding!("qsharp-runner");

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

impl From<Vec<stateless::Error>> for QsError {
    fn from(errors: Vec<stateless::Error>) -> Self {
        let mut error_message = String::new();

        for error in errors {
            if let Some(stack_trace) = error.stack_trace() {
                error_message.push_str(&format!("Stack trace: {}", stack_trace));
            }

            error_message.push_str(&format!(", error: {:?}", error));
        }

        QsError::ErrorMessage { error_text: error_message }
    }
}

pub fn run_qs(source: &str) -> Result<ExecutionState, QsError> {
    let source_map = SourceMap::new(vec![("temp.qs".into(), source.into())], Some("".into()));

    let context = stateless::Context::new(true, source_map)?;
    let mut rec = ExecutionState::default();
    let result = context.eval(&mut rec)?;

    rec.set_result(result.to_string());
    return Ok(rec);
}

pub struct QubitState {
    id: String,
    amplitude_real: f64,
    amplitude_imaginary: f64,
}

pub struct ExecutionState {
    states: Vec<QubitState>,
    qubit_count: u64,
    messages: Vec<String>,
    result: Option<String>,
}

impl ExecutionState {
    // Add a function to set the result
    fn set_result(&mut self, result: String) {
        self.result = Some(result);
    }
}

impl Default for ExecutionState {
    fn default() -> Self {
        Self {
            states: Vec::new(),
            qubit_count: 0,
            messages: Vec::new(),
            result: None,
        }
    }
}

impl Receiver for ExecutionState {
    fn state(
        &mut self,
        states: Vec<(BigUint, Complex64)>,
        qubit_count: usize,
    ) -> Result<(), output::Error> {
        self.qubit_count = qubit_count as u64;
        self.states = states.iter().map(|(qubit, amplitude)| {
            QubitState {
                id: output::format_state_id(&qubit, qubit_count),
                amplitude_real: amplitude.re,
                amplitude_imaginary: amplitude.im,
            }
        }).collect();

        Ok(())
    }

    fn message(&mut self, msg: &str) -> Result<(), output::Error> {
        self.messages.push(msg.to_string());
        Ok(())
    }
}

#[test]
fn test_hello() {
    let source = std::fs::read_to_string("tests/assets/hello.qs").unwrap();
    let result = run_qs(&source).unwrap();

    assert_eq!(result.messages.len(), 1);
    assert_eq!(result.messages[0], "Hello");

    assert_eq!(result.qubit_count, 0);
    assert_eq!(result.states.len(), 0);
}

#[test]
fn test_entanglement() {
    let source = std::fs::read_to_string("tests/assets/entanglement.qs").unwrap();
    let result = run_qs(&source).unwrap();

    assert_eq!(result.messages.len(), 0);
    assert_eq!(result.qubit_count, 2);
    assert_eq!(result.states.len(), 2);
}

#[test]
fn test_teleportation() {
    let source = std::fs::read_to_string("tests/assets/teleportation.qs").unwrap();
    let result = run_qs(&source).unwrap();

    assert_eq!(result.messages.len(), 1);
    assert_eq!(result.messages[0], "Teleported: true");

    assert_eq!(result.qubit_count, 0);
    assert_eq!(result.states.len(), 0);
}