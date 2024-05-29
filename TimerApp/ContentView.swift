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
    @State private var showingOptions = false
    @State private var trackMoneyMode = false
    @State private var dollarsPerHour: Double = 0.0
    @State private var totalEarnings: Double = 0.0
    @State private var lapEarnings: [Double] = []
    
    var body: some View {
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        VStack {
            // Options button
            HStack {
                Spacer()
                Button(action: {
                    showingOptions = true
                }) {
                    Text("Options")
                }
            }
            
            // Display time
            Text(formatTime(seconds: timerValue))
                .font(.largeTitle)
            
            // Money mode, display total earning
            if trackMoneyMode {
                Text("Total Earnings: $\(String(format: "%.2f", totalEarnings))")
            }
            
            // Start/Stop Button
            Button(action: {
                timerRunning.toggle()
            }) {
                if timerValue == 0 {
                    Text(timerRunning ? "Pause" : "Start")
                }
                else {
                    Text(timerRunning ? "Pause" : "Resume")
                }
                
                
            }
            
            // Lap button
            Button(action: {
                if timerRunning {
                    laps.append(lapValue)
                    lapEarnings.append(calculateLapEarnings())
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
                        if trackMoneyMode {
                            Text("\(String(format: "$%.2f", lapEarnings[index]))")
                        }
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
        .frame(width:250, height:300)
        .onReceive(timer) { _ in
            if timerRunning {
                timerValue += 1
                lapValue += 1
                if trackMoneyMode {
                    totalEarnings = calculateTotalEarnings()
                }
            }
        }
        .sheet(isPresented: $showingOptions) {
            OptionsView(trackMoneyMode: $trackMoneyMode, dollarsPerHour: $dollarsPerHour, laps: $laps, lapEarnings: $lapEarnings)
        }
        
        
    }
    
    func calculateTotalEarnings() -> Double {
           return Double(timerValue) / 3600 * dollarsPerHour
       }
    
    func calculateLapEarnings() -> Double {
        return Double(lapValue) / 3600 * dollarsPerHour
    }
    
    func formatTime(seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: TimeInterval(seconds))!
    }
    
}

struct OptionsView: View {
    @Binding var trackMoneyMode: Bool
    @Binding var dollarsPerHour: Double
    @Binding var laps: [Int]
    @Binding var lapEarnings: [Double]
    @State private var tempTrackMoneyMode: Bool
    @State private var tempDollarsPerHour: Double
    @Environment(\.presentationMode) var presentationMode

    init(trackMoneyMode: Binding<Bool>, dollarsPerHour: Binding<Double>, laps: Binding<[Int]>, lapEarnings: Binding<[Double]>) {
        _trackMoneyMode = trackMoneyMode
        _dollarsPerHour = dollarsPerHour
        _laps = laps
        _lapEarnings = lapEarnings
        _tempTrackMoneyMode = State(initialValue: trackMoneyMode.wrappedValue)
        _tempDollarsPerHour = State(initialValue: dollarsPerHour.wrappedValue)
    }

    
    var body: some View {
        VStack {
            Toggle(isOn: $tempTrackMoneyMode) {
                Text("Track Money Mode")
            }
            
            HStack{
                Spacer()
                Text("$")
                TextField("Dollars per hour", value: $tempDollarsPerHour, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("per hour")
                Spacer()
            }

            HStack {
                // Cancel Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }
                
                Spacer()
                
                // Submit Button
                Button(action: {
                    trackMoneyMode = tempTrackMoneyMode
                    dollarsPerHour = tempDollarsPerHour
                    if !tempTrackMoneyMode {
                        lapEarnings = []
                    } else {
                        lapEarnings = laps.map { Double($0) / 3600 * dollarsPerHour }
                    }
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Submit")
                }
            }
        }
        .frame(width: 200, height: 150)
    }
}



#Preview {
    ContentView()
}
