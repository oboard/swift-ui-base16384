//
//  ContentView.swift
//  base16384
//
//  Created by oboard on 2024/2/12.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    //    @Environment(\.modelContext) private var modelContext
    //    @Query private var items: [Item]
    
    @State private var textInput: String = "Example"
    @State private var textOutput: String = "彞吖菁穥㴀"
    @State private var selectedTab = 0
    
    var content: some View {
        VStack {
            TextEditor(text: $textInput)
                .onChange(of: textInput) { oldValue, newValue in
                    submit()
                }
                .padding()
                .scrollContentBackground(.hidden)
                .background(.ultraThickMaterial)
                .cornerRadius(10)
            
            TextEditor(text: $textOutput)
                .padding()
                .scrollContentBackground(.hidden)
                .background(.ultraThickMaterial)
                .cornerRadius(10)
            
        }.padding()
    }
    
    var body: some View {
#if os(iOS)
        NavigationView {
            TabView(selection: $selectedTab) {
                content
                    .tabItem {
                        Image(systemName: "lock")
                        Text("Encode")
                    }.tag(0)
                
                content
                    .tabItem {
                        Image(systemName: "key")
                        Text("Decode")
                    }.tag(1)
            }
            .onChange(of: selectedTab) { oldTab, newTab in
                if (oldTab != newTab) {
                    swap(&textInput, &textOutput)
                }
                submit()
            }.navigationTitle("base16384")
        }
#endif
#if os(macOS)
        TabView(selection: $selectedTab) {
            content
                .tabItem {
                    Image(systemName: "lock")
                    Text("Encode")
                }.tag(0)
            
            content
                .tabItem {
                    Image(systemName: "key")
                    Text("Decode")
                }.tag(1)
        }
        .onChange(of: selectedTab) { oldTab, newTab in
            if (oldTab != newTab) {
                swap(&textInput, &textOutput)
            }
            submit()
        }
        .frame(minWidth: 400, minHeight: 600)
        .padding()
#endif
        //#if os(iOS)
        //#endif
        //detail: {
        //            Text("Select an item")
        //        }
    }
    
    private func submit() {
        if (selectedTab == 0){
            textOutput = toSource(input: encode(input: toUint8Array(source: textInput)))
        } else {
            textOutput = toSource8(input: decode(input: toUint16Array(source: textInput)))
        }
    }
    
    private func clearText() {
        withAnimation {
            //            let newItem = Item(timestamp: Date())
            //            modelContext.insert(newItem)
            textInput = ""
        }
    }
    
    
    init() {
        submit()
    }
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            for index in offsets {
    //                modelContext.delete(items[index])
    //            }
    //        }
    //    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
