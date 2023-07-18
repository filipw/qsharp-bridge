//
//  ContentView.swift
//  strathweb.qsharp-bridge.sample
//
//  Created by Filip W on 17.07.23.
//

import SwiftUI
import CodeEditorView
import LanguageSupport

struct ContentView: View {
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Choose a sample").font(.title2)
                List(Samples.data) { item in
                    NavigationLink(destination: SinglePanelView(code: item.code)
                    ) {
                        Text(item.name)
                    }
                }.listStyle(.sidebar)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SinglePanelView: View {
    @State private var shots = 1.0
    @State private var isEditing = false
    @State var code: String
    @State private var position = CodeEditor.Position()
    @State private var messages: Set<Located<Message>> = Set()
    @State private var showMinimap = true
    @State private var wrapText = true
    @State private var isPlaying = false
    
    @State var executionState : ExecutionState?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                CodeEditor(text: $code, position: $position, messages: $messages, layout: CodeEditor.LayoutConfiguration(showMinimap: showMinimap, wrapText: wrapText)).frame(height: geometry.size.height / 2)
                
                Divider()
                HStack {
                    Text("Shots: \(Int(shots))")
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(isEditing ? .red : .blue)
                    
                    Slider(value: $shots,
                                in: 1...1000,
                                onEditingChanged: { editing in
                                    isEditing = editing
                                }
                            )
                }
                
                Button(action: {
                    executionState = try! runQs(source: code)
                }, label: {
                    Image(systemName: "play.fill")
                    Text("Run code!")
                }).padding()
                
                
                if let result = executionState {
                    ForEach(result.messages, id: \.self) { element in
                        Text(element)
                        
                    }.padding()
                        .background(Color.yellow)
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct Sample : Identifiable {
    let id = UUID()
    let name: String
    let code: String
}

struct Samples {
    static let data = [
        Sample(name: "basic.qs", code: """
namespace MyQuantumApp {
    @EntryPoint()
        operation Main() : Unit {
        Message("Hello");
    }
}
"""),
        Sample(name: "entanglement.qs", code: """
namespace Demos {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Diagnostics;

    @EntryPoint()
    operation Run() : (Result, Result) {
        use (control, target) = (Qubit(), Qubit());

        H(control);
        CNOT(control, target);
        
        DumpMachine();

        let resultControl = MResetZ(control);
        let resultTarget = MResetZ(target);
        return (resultControl, resultTarget);
    }
}
"""),
        Sample(name: "teleportation.qs", code: """
namespace teleportation {

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Random;

    @EntryPoint()
    operation Start() : Bool {
        use (message, resource, target) = (Qubit(), Qubit(), Qubit());
        PrepareState(message);

        Teleport(message, resource, target);
        Adjoint PrepareState(target);
        let outcome = M(target) == Zero;
        Message($"Teleported: {outcome}");
        return outcome;
    }

    operation Teleport(message : Qubit, resource : Qubit, target : Qubit) : Unit {
        // create entanglement between resource and target
        H(resource);
        CNOT(resource, target);

        // reverse Bell circuit on message and resource
        CNOT(message, resource);
        H(message);

        // mesaure message and resource
        let messageResult = MResetZ(message) == One;
        let resourceResult = MResetZ(resource) == One;

        // and decode state
        DecodeTeleportedState(messageResult, resourceResult, target);
    }

    operation PrepareState(q : Qubit) : Unit is Adj + Ctl {
        Rx(1. * PI() / 2., q);
        Ry(2. * PI() / 3., q);
        Rz(3. * PI() / 4., q);
    }

    operation DecodeTeleportedState(messageResult : Bool, resourceResult : Bool, target : Qubit) : Unit {
        if not messageResult and not resourceResult {
            I(target);
        }
        if not messageResult and resourceResult {
            X(target);
        }
        if messageResult and not resourceResult {
            Z(target);
        }
        if messageResult and resourceResult {
            Z(target);
            X(target);
        }
    }
}
""")
    ]
}
