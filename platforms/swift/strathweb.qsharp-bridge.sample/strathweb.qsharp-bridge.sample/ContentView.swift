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
    @State private var code =
"""
namespace MyQuantumApp {
    @EntryPoint()
        operation Main() : Unit {
        Message("Hello");
    }
}
"""
    @State private var position = CodeEditor.Position()
    @State private var messages: Set<Located<Message>> = Set()
    @State private var showMinimap = true
    @State private var wrapText = true
    
    @State var executionState : ExecutionState?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                CodeEditor(text: $code, position: $position, messages: $messages, layout: CodeEditor.LayoutConfiguration(showMinimap: showMinimap, wrapText: wrapText)).frame(height: geometry.size.height / 2)
                
                Divider()
                Button(action: {
                    executionState = try! runQs(source: code)
                }, label: {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
