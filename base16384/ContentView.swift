//
//  ContentView.swift
//  base16384
//
//  Created by oboard on 2024/2/12.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var textInput: String = ""

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
//                    .blur(radius: 4)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.5)
                
                VStack {
                    
                    ZStack(alignment: .topLeading) {
                        
                        TextEditor(text: $textInput)
                            .padding()
                            .scrollContentBackground(.hidden)
                            .background(.thinMaterial)
                            .cornerRadius(10)
                        if textInput.isEmpty {
                           Text("Enter text here...")
                               .opacity(0.5)
                               .padding()
                       }
                    }
                    .padding()
                    Text("You entered: \(toSource(input: encode(input: textInput)))")
                        .padding()
                }.padding()
                //
                //                Rectangle()
                //                    .fill(Color.green)
                //                    .frame(width: 100, height: 100)
                //                    .overlay(Text("Transparent Blur Background"))
                //                    .cornerRadius(10)
                //                    .padding()
                
            }
        }
//#if os(iOS)
//#endif
//detail: {
//            Text("Select an item")
//        }
    }

    private func clearText() {
        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
            textInput = ""
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
