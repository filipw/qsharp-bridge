//
//  ContentView.swift
//  strathweb.qsharp-bridge.sample
//
//  Created by Filip W on 17.07.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Choose a sample").font(.title2)
                List(Samples.data) { item in
                    NavigationLink(destination: SinglePanelView(code: item.code, title: item.name)
                    ) {
                        HStack {
                            Image(systemName: "doc.plaintext")
                            Text(item.name)
                        }
                    }
                }.listStyle(.plain)
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
