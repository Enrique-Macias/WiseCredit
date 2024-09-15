//
//  CustomTabBar.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/14/24.
//

import Foundation
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        HStack {
            // Home Tab Button
            TabButton(icon: "house.fill", title: "Home", selectedTab: $selectedTab, tab: .home)
            
            // Credit Card Tab Button
            TabButton(icon: "creditcard", title: "Cards", selectedTab: $selectedTab, tab: .stats)
            
            // Profile Tab Button
            TabButton(icon: "person.fill", title: "Profile", selectedTab: $selectedTab, tab: .profile)
            
            Spacer()
            
            // Plus Button on the right
            PlusButton()
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 10)
        .background(Color.black)
        .cornerRadius(30)
        .padding(.horizontal)
        .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 10)
        .positionedAtBottom()
    }
}

enum Tab {
    case home
    case stats
    case profile
}

struct TabButton: View {
    let icon: String
    let title: String
    @Binding var selectedTab: Tab
    let tab: Tab

    var body: some View {
        Button(action: {
            withAnimation {
                selectedTab = tab
            }
        }) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                
                // Show title only when the tab is selected
                if selectedTab == tab {
                    Text(title)
                        .fontWeight(.bold)
                        .transition(.opacity)
                }
            }
            .foregroundColor(selectedTab == tab ? .white : .gray)
            .padding(.vertical, 10)
            .padding(.horizontal, selectedTab == tab ? 20 : 10)
            .background(selectedTab == tab ? Color.gray : Color.clear)
            .cornerRadius(20)
            .animation(.easeInOut, value: selectedTab) // Smooth animation
        }
    }
}

struct PlusButton: View {
    var body: some View {
        Button(action: {
            // Acción para el botón de "+"
        }) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .padding(20)
                .background(Color.black)
                .clipShape(Circle())
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
        }
        .offset(x: 10)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(.home))
            .previewLayout(.sizeThatFits)
    }
}

extension View {
    func positionedAtBottom() -> some View {
        VStack {
            Spacer() // Fills up the space above
            self
        }
    }
}
