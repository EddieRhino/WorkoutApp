//
//  EditWorkouts.swift
//  Fitness App
//
//  Created by Eddie Reinhardt on 6/28/25.
//

import SwiftUI

struct EditWorkouts: View {
    @Binding var workoutOptions: [String]
    var body: some View {
        VStack {
            List {
                ForEach(workoutOptions.indices.filter{workoutOptions[$0] != "Add New Workout"}, id: \.self) { item in
                    Text(workoutOptions[item])
                }
                .onDelete { indexSet in
                    workoutOptions.remove(atOffsets: indexSet)
                    saveWorkoutOptions(workoutOptions)
                }
            }
        }
    }
}

struct EditWorkouts_Previews: PreviewProvider {
    @State static var sampleWorkoutOptions = [
            "Bench Press", "Squat", "Deadlift", "Add New Workout"
        ]
    static var previews: some View {
        EditWorkouts(
            workoutOptions: $sampleWorkoutOptions
        )
    }
}
