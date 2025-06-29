//
//  PastWorkouts.swift
//  Fitness App
//
//  Created by Eddie Reinhardt on 6/28/25.
//

import SwiftUI

struct PastWorkouts: View {
    @State public var PastWorkoutList: [PastWorkout] = []
    var body: some View {
        VStack{
            Text("Past Workouts").padding(.top).font(.largeTitle)
            Spacer()
            List{
                ForEach(PastWorkoutList.reversed()){past in
                    DisclosureGroup{
                        ForEach(past.exercises){ex in
                            Text("\(ex.name): \(ex.reps) reps at \(String(format: "%g", ex.weight)) lbs")
                        }
                    } label: {
                        Text("\(dateFormatter.string(from: past.date)) - \(past.title) - \(past.exercises.count) Exercises")
                            .foregroundColor(Color.black)
                            .font(.headline)
                    }
                }
                .onDelete { indexSet in
                    PastWorkoutList.remove(atOffsets: indexSet)
                    savePastWorkouts(PastWorkoutList)
                }
            }
        }
        .onAppear{
            PastWorkoutList = loadPastWorkouts()
        }
    }
}
struct PastWorkout: Identifiable, Codable{
    var id = UUID()
    var date: Date
    var title: String
    var exercises: [Exercise]
}

func savePastWorkouts(_ PastWorkoutList: [PastWorkout]){
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(PastWorkoutList) {
        UserDefaults.standard.set(encoded, forKey: "SavedPastWorkoutList")
    }
}

func loadPastWorkouts() -> [PastWorkout] {
    if let savedData = UserDefaults.standard.data(forKey: "SavedPastWorkoutList"){
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([PastWorkout].self, from: savedData){
            return decoded
        }
    }
    return []
}
                    
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

struct PastWorkouts_Previews: PreviewProvider {
    static var previews: some View {
        PastWorkouts()
    }
}

