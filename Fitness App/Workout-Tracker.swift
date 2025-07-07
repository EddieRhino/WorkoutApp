//
//  Workout-Tracker.swift
//  Fitness App
//
//  Created by Eddie Reinhardt on 6/21/25.
//

import SwiftUI

struct Workout_Tracker: View {
    var body: some View{
        NavigationView{
            VStack{
                NavigationLink(destination: PushWorkoutTracker()) {
                    Text("Push Workout")
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                NavigationLink(destination: PullWorkoutTracker()) {
                    Text("Pull Workout")
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                NavigationLink(destination: LegsWorkoutTracker()) {
                    Text("Legs Workout")
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                NavigationLink(destination: UpperWorkoutTracker()) {
                    Text("Upper Body Workout")
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                NavigationLink(destination: CustomWorkoutTracker()) {
                    Text("Custom Workout")
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct Workout_Tracker_Previews: PreviewProvider {
    static var previews: some View {
        Workout_Tracker()
    }
}
