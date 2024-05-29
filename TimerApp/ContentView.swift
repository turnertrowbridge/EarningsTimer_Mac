//
//  ContentView.swift
//  TimerApp
//
//  Created by Turner Trowbridge on 5/28/24.
//

import SwiftUI

struct ContentView: View {
    @State private var timerValue = 0
    @State private var lapValue = 0
    @State private var timerRunning = false
    @State private var laps: [Int] = []
    @State private var showingResetAlert = false
    
    var body: some View {
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        VStack {
            // Display time
            Text(formatTime(seconds: timerValue))
                .font(.largeTitle)
            
            // Start/Stop Button
            Button(action: {
                timerRunning.toggle()
            }) {
                Text(timerRunning ? "Stop" : "Start")
                
            }
            
            // Lap button
            Button(action: {
                if timerRunning {
                    laps.append(lapValue)
                    lapValue = 0
                }
            }) {
                Text("Lap")
            }
            
            // Show laps
            List {
                ForEach(laps.indices.reversed(), id: \.self) { index in
                    HStack {
                        Text("Lap \(index + 1):")
                        Text(formatTime(seconds: laps[index]))
                    }
                }
            }
            
            // Reset Button
            Button(action: {
                showingResetAlert = true
            }) {
                Text("Reset")
            }.alert(isPresented: $showingResetAlert) {
                Alert(title: Text("Reset Timer"), message: Text("Are you sure you want to reset the timer?"), primaryButton: .destructive(Text("Reset")) {
                    timerRunning = false
                    timerValue = 0
                    laps = []
                }, secondaryButton: .cancel())
            }
        }
        .padding()
        .frame(width:200, height:300)
        .onReceive(timer) { _ in
            if timerRunning {
                timerValue += 1
                lapValue += 1
            }
        }
        

    }
    
    
    func formatTime(seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: TimeInterval(seconds))!
    }
    
}

#Preview {
    ContentView()
}
