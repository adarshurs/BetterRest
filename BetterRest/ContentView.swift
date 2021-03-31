//
//  ContentView.swift
//  BetterRest
//
//  Created by Adarsh Urs on 19/03/21.
//

import SwiftUI

struct ContentView: View {
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    
    @State private var alertTitle = "Error"
    @State private var alertMessage = "Sorry, there was a problem calculating your bedtime."
    @State private var showingAlert = false
    
    
    private var sleepAt : String {
    let model = SleepCalc()
    let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
    let hour = (components.hour ?? 0) * 60 * 60
    let minute = (components.minute ?? 0) * 60
    
    do{
        let prediction = try model.prediction(wake: sleepAmount, estimatedSleep: Double(hour + minute), coffee: Double(coffeeAmount))

        let sleepTime = wakeUp - prediction.actualSleep
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short

        alertMessage = formatter.string(from: sleepTime)
        alertTitle = "Your ideal bedtime is…"
        return formatter.string(from: sleepTime)
    } catch{
    }
        return "0"
    }
    
    var body: some View {
            NavigationView{
                Form{
                    Section(header: Text("Wake at")) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
//                        .datePickerStyle(WheelDatePickerStyle())
                    }
                    
                    Section(header: Text("Sleep")) {
                    Text("Desired Amount of Sleep")
                        .font(.headline)
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25){
                        Text("\(sleepAmount, specifier: "%g") hours" )
                        }
                    }
                    Section(header: Text("Coffee")) {
                        Text("Daily coffee intake")
                            .font(.headline)
                        
                        Picker("Coffee intake", selection: $coffeeAmount){
                            ForEach(1 ..< 21){
                                if $0 == 1{
                                    Text("1 cup")
                                } else {
                                    Text("\($0) cups")
                                }
                            }
                        }
                    }
                    
                    Text("Recommended to Sleep at \(sleepAt)")
                    
//                    .alert(isPresented: $showingAlert) {
//                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//                        }
                    }
                .navigationBarTitle("BetterRest")
            }
        }
    
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
