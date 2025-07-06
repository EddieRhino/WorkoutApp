//
//  ContentView.swift
//  Fitness App
//
//  Created by Eddie Reinhardt on 6/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("WELCOME TO FITNESS APP")
                    .font(.title)
                    .padding()
                NavigationLink("Continue"){
                    MainScreen()
                }
                
                .padding()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

