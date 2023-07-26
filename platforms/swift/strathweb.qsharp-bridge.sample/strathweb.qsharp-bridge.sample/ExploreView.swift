//
//  ContentView.swift
//  strathweb.qsharp-bridge.sample
//
//  Created by Filip W on 17.07.23.
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationView {
            VStack {
                List(Samples.data) { item in
                    NavigationLink(destination: SinglePanelView(code: item.code, title: item.name)
                    ) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Image(systemName: "doc.plaintext").foregroundColor(.accentColor)
                                Text(item.name).font(.headline)
                            }.padding(.bottom, 5)
                            DifficultyView(rating: item.difficulty)
                        }
                    }
                }.listStyle(.plain)
            }.padding()
                .navigationTitle("Explore")
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
