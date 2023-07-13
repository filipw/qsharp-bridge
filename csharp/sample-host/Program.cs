using uniffi.qsharp_runner;

var qsharpSource = """
namespace MyQuantumApp {
        @EntryPoint()
        operation Main() : Unit {
            Message("Hello");
        }
}
""";

var result = QsharpRunnerMethods.RunQs(qsharpSource);

foreach (var msg in result.messages) {
    Console.WriteLine(msg);
}