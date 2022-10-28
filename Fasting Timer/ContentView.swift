//
//  ContentView.swift
//  Fasting Timer
//
//  Created by Azizbek Asadov on 28/10/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack {
            // MARK: Background
            Color.black
                .ignoresSafeArea()
            MainView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
