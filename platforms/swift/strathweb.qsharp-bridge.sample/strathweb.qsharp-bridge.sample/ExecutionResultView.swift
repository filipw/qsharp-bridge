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
            
            Divider().padding(.leading, 50).padding(.trailing, 50)
            if executionStates.indices.contains(currentIndex - 1) {
                SingleShotView(executionState: executionStates[currentIndex - 1])
            }
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
                
                Label {
                    Text("Return".uppercased()).font(.caption)
                } icon: {
                    Image(systemName: "doc.badge.gearshape")
                }
                
                Text(toKetIfPossible(input: executionState.result)).font(.title).padding()
                
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
    }
    
    func toKetIfPossible(input: String?) -> String {
        if var result = input {
            if result == "Zero" { result = "|0⟩" }
            if result == "One" { result = "|1⟩" }

            result = result.replacingOccurrences(of: "(", with: "|")
            result = result.replacingOccurrences(of: "[", with: "|")
            result = result.replacingOccurrences(of: ")", with: "⟩")
            result = result.replacingOccurrences(of: "]", with: "⟩")
            result = result.replacingOccurrences(of: " ", with: "")
            result = result.replacingOccurrences(of: ",", with: "")
            result = result.replacingOccurrences(of: "Zero", with: "0")
            result = result.replacingOccurrences(of: "One", with: "1")
            
            return result
        }
        
        return "None"
    }
}

struct ExecutionResultView_Previews: PreviewProvider {
    @State static var executionStates = [ExecutionState(states: [], qubitCount: 0, messages: ["foo", "bar"], result: "(One, One)")]
    
    static var previews: some View {
        ExecutionResultView(executionStates: $executionStates)
    }
}
