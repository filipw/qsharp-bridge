using uniffi.qsharp_bridge;

var qsharpSource = """
namespace MyQuantumApp {
        @EntryPoint()
        operation Main() : Unit {
            Message("Hello");
        }
}
""";

var result = QsharpBridgeMethods.RunQs(qsharpSource);
PrintOutcome(result);

Console.WriteLine();
Console.WriteLine();

Console.WriteLine("Shots: 10");
var resultShots = QsharpBridgeMethods.RunQsShots(qsharpSource, 10);
foreach (var innerResult in resultShots) {
    PrintOutcome(innerResult);
}

void PrintOutcome(ExecutionState result)
{
    Console.WriteLine("Messages:");
    foreach (var msg in result.messages) {
        Console.WriteLine(msg);
    }

    Console.WriteLine("Output:");
    Console.WriteLine(result.result);
}