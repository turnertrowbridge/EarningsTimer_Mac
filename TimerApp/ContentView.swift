//
//  ContentView.swift
//  TimerApp
//
//  Created by Turner Trowbridge on 5/28/24.
//

import SwiftUI

struct ContentView: View {
    @State private var timerRunning = false
    @State private var timerText = "00:00"
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text(timerText)
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                timerRunning.toggle()
            }) {
                Text(timerRunning ? "Stop" : "Start")
            }
            .padding()
        }
        .onReceive(timer, perform: { _ in
            if timerRunning {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "mm:ss"
                timerText = dateFormatter.string(from: Date())
            }
        })
        
    }
}

#Preview {
    ContentView()
}
