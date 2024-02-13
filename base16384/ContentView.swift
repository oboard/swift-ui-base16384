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
    @State private var textOutput: String = ""
    
    @State private var selectedSegment = 0
    let segments = ["Encode", "Decode"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("Wallpaper")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.5)
                
                VStack {
                    
                    Picker("",selection: $selectedSegment) {
                           ForEach(0..<segments.count) { index in
                               Text(segments[index])
                           }
                       }
                    .pickerStyle(.segmented)
                       .padding()
                                   
                    
                    ZStack(alignment: .topLeading) {
                        
                        TextEditor(text: $textInput)
                            .onChange(of: textInput) { oldValue, newValue in
                                if (selectedSegment == 0){
                                    textOutput = toSource(input: encode(input: toUint8Array(source: textInput)))
                                } else {
                                    do {
                                        textOutput = toSource8(input: try decode(input: toUint16Array(source: textInput)))
                                    } catch {
                                        textOutput = "错误"
                                    }
                                }
                            }
                            .padding()
                            .scrollContentBackground(.hidden)
                            .background(.thinMaterial)
                            .cornerRadius(10)
                    }
                    
                    
                    Text("base16384").italic().monospaced()
                        .foregroundStyle(LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color.blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )).shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    
                    ZStack(alignment: .topLeading) {
                        
                        TextEditor(text: $textOutput)
                            .padding()
                            .scrollContentBackground(.hidden)
                            .background(.thinMaterial)
                            .cornerRadius(10)
                    }
                    
                    
                }.padding()
                
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
