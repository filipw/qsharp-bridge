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

Console.WriteLine("Messages:");
foreach (var msg in result.messages) {
    Console.WriteLine(msg);
}

Console.WriteLine("Output:");
Console.WriteLine(result.result);