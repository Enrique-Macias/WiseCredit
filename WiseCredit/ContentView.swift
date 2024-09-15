//
//  ContentView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/14/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .stats:
                    CardsView()  // Aquí la vista de Cards
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
