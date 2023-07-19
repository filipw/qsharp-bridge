//
//  SwiftUIView.swift
//  strathweb.qsharp-bridge.sample
//
//  Created by Filip W on 18.07.23.
//

import SwiftUI
import CodeEditorView
import LanguageSupport

struct SinglePanelView: View {
    @State var code: String
    @State var title: String
    
    @State private var shots = 1.0
    @State private var isEditing = false
    @State private var showResults = false
    @State private var position = CodeEditor.Position()
    @State private var messages: Set<Located<Message>> = Set()
    @State private var showMinimap = true
    @State private var wrapText = true
    @State private var isPlaying = false
    
    @State var executionStates : [ExecutionState] = []
    
    var body: some View {
        ScrollView {
            VStack {
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
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            DispatchQueue.main.async {
                                showResults = false
                            }
                            
                            let results = try! runQsShots(source: code, shots: UInt64(shots))
                            print(results.count)
                            
                            DispatchQueue.main.async {
                                executionStates = results
                                showResults = true
                            }
                        }
                    }, label: {
                        Image(systemName: "play.fill")
                    }).padding()
                }
                
                Divider()
                
                CodeEditor(text: $code, position: $position, messages: $messages, layout: CodeEditor.LayoutConfiguration(showMinimap: showMinimap, wrapText: wrapText)).frame(height: 450)
                
                Divider()
                
                if showResults {
                    ExecutionResultView(executionStates: $executionStates)
                }
                Spacer()
            }
            .navigationTitle(title)
            .padding()
        }
    }
}

struct SinglePanelView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SinglePanelView(code: Samples.data[1].code, title: Samples.data[1].name)
        }
    }
}

extension ExecutionState: Identifiable {
    public var id: String {
        return UUID().uuidString
    }
}
