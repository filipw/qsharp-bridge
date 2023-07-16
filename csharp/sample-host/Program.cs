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
PrintOutcome(result);

Console.WriteLine();
Console.WriteLine();

Console.WriteLine("Shots: 10");
var resultShots = QsharpRunnerMethods.RunQsShots(qsharpSource, 10);
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