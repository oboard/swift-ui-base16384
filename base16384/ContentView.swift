//
//  ContentView.swift
//  base16384
//
//  Created by oboard on 2024/2/12.
//

import SwiftUI

extension View {
    /// Layers the given views behind this ``TextEditor``.
    func clearTextEditorBackground() -> some View {
//        if #available(iOS 16.0, *) {
//            return self.scrollContentBackground(.hidden)
//        } else {
        UITextView.appearance().backgroundColor = .clear
        return self
//        }
    }
}

struct ContentView: View {
    
    init() {
        submit()
    }
    
    //    @Environment(\.modelContext) private var modelContext
    //    @Query private var items: [Item]
    
    @State private var textInput: String = "Example"
    @State private var textOutput: String = "彞吖菁穥㴀"
    @State private var selectedTab = 0
#if os(tvOS)
    var content: some View {
        VStack {
            TextField("", text: $textInput)
                .onChange(of: textInput) { newValue in
                    submit()
                }
            
            TextField("", text: $textOutput)
            
        }.padding().background(.thickMaterial).cornerRadius(10)
    }
#else
    var content: some View {
        VStack {
            TextEditor(text: $textInput)
                .onChange(of: textInput) {
                    newValue in
                    submit()
                }
                .padding()
                .clearTextEditorBackground()
                .background(.thickMaterial)
                .cornerRadius(10)
            //                .border(.ultraThickMaterial)
            //                .buttonBorderShape(.roundedRectangle)
            //                .scrollContentBackground(.hidden)
            
            TextEditor(text: $textOutput)
                .padding()
                .clearTextEditorBackground()
            //                .scrollContentBackground(.hidden)
                .background(.ultraThickMaterial)
                .cornerRadius(10)
            
        }.padding()
    }
#endif
    
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
            .onChange(of: selectedTab) {
                newTab in
                swap(&textInput, &textOutput)
                submit()
            }.navigationTitle("base16384")
        }
#else
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
        .onChange(of: selectedTab) { newTab in
            swap(&textInput, &textOutput)
            submit()
        }
        .frame(minWidth: 400, minHeight: 600)
        .padding()
#endif
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
            textInput = ""
        }
    }
    
}

#Preview {
    ContentView()
}
