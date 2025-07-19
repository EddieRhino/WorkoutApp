//
//  MainScreen.swift
//  Fitness App
//
//  Created by Eddie Reinhardt on 6/19/25.
//

import SwiftUI

struct MainScreen: View {
    var body: some View {
        NavigationStack{
            VStack{
                Text("I Want To:").bold().font(.title).padding()
                Spacer()
                NavigationLink(destination: Workout_Tracker()) {
                    Text("Log A Workout")
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                NavigationLink(destination: PastWorkouts()){
                    Text("View A Past Workout")
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                NavigationLink(destination: PastWorkoutLog()){
                    Text("Log A Past Workout")
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}


