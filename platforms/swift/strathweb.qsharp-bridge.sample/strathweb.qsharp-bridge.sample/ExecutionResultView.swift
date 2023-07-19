//
//  ExecutionResultView.swift
//  strathweb.qsharp-bridge.sample
//
//  Created by Filip W on 18.07.23.
//

import SwiftUI

struct ExecutionResultView: View {
    @State var currentIndex = 1
    @Binding var executionStates : [ExecutionState]
    
    var body: some View {
        VStack {
                Label("Results", systemImage: "list.clipboard").font(.headline).padding()
            HStack {
                Spacer()
                Button(action: {
                    currentIndex -= 1
                }, label: {
                    Image(systemName: "chevron.left").font(.subheadline)
                })
                .disabled(currentIndex <= 1)
                
                Spacer()
                
                if executionStates.count > 1 {
                    Text("\(currentIndex)/\(executionStates.count)").font(.subheadline).foregroundColor(.primary)
                } else {
                    Text("Single shot").font(.subheadline).foregroundColor(.primary)
                }
                
                Spacer()
                Button(action: {
                    currentIndex += 1
                }, label: {
                    Image(systemName: "chevron.right").font(.subheadline)
                })
                .disabled(currentIndex == executionStates.count)
                Spacer()
            }
            
            if executionStates.indices.contains(currentIndex - 1) {
                SingleShotView(executionState: executionStates[currentIndex - 1])
            }
//            ForEach(executionStates) { result in
//                Text(result.result ?? "None")
//                ForEach(result.messages, id: \.self) { element in
//                    Text(element).background(Color.yellow)
//
//                }.padding()
//            }
        }
    }
    
    func getShotCaption() -> String {
        if executionStates.count > 1 {
            return "\(currentIndex)/\(executionStates.count)"
        }
        
        return "Single shot"
    }
}

struct SingleShotView: View {
    var executionState: ExecutionState
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(executionState.result ?? "None").font(.caption).padding()
                Spacer()
            }
            Divider()
            VStack {
                ForEach(executionState.messages, id: \.self) { element in
                    Text(element).font(.caption)
                }
                Spacer()
            }
        }.padding()
        
//        VStack {
//            Text(executionState.result ?? "None").font(.caption).padding()
//            ForEach(executionState.messages, id: \.self) { element in
//                Text(element).background(Color.yellow)
//            }
//        }
    }
}

//struct ExecutionResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExecutionResultView(executionStates: [
//            ExecutionState(states: [], qubitCount: 0, messages: ["foo", "bar"], result: "(One, One)")
//        ])
//    }
//}
