//
//  ContentView.swift
//  TimerApp
//
//  Created by Turner Trowbridge on 5/28/24.
//

import SwiftUI

struct ContentView: View {
    @State private var timerValue = 0
    @State private var timerRunning = false
    
    var body: some View {
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

        VStack {
            Text(formatTime(seconds: timerValue))
                .font(.largeTitle)
            
            Button(action: {
                timerRunning.toggle()
            }) {
                Text(timerRunning ? "Stop" : "Start")
            }
        }
        .padding()
        .frame(width:150, height: 100)
        .onReceive(timer) { _ in
            if timerRunning {
                timerValue += 1
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
