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

struct SinglePanelView_Previews: PreviewProvider {
    static var previews: some View {
        SinglePanelView(code: Samples.data[1].code)
    }
}
