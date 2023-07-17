//
//  ContentView.swift
//  strathweb.qsharp-bridge.sample
//
//  Created by Filip W on 17.07.23.
//

import SwiftUI

struct ContentView: View {
    let code = """
        namespace MyQuantumApp {
                @EntryPoint()
                operation Main() : Unit {
                    Message("Hello");
                }
        }
    """
    
    @State var executionState : ExecutionState?
    
    var body: some View {
       
        VStack {
            Text(code).padding()
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
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
