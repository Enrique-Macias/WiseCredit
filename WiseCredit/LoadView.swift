//
//  LoadView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/15/24.
//

import SwiftUI

struct LoadView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ZStack {
            Color(colorScheme == .light ? Color.black : .white)
                .edgesIgnoringSafeArea(.all)
            Image("BOT-logo")
                .foregroundColor(Color(colorScheme == .light ? .white : Color.white))
                .frame(width: 10, height: 10)
                .padding(.all, 20)
            
        }
    }
}

struct LoadView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadView()
                .preferredColorScheme(.light) // Modo claro
            LoadView()
                .preferredColorScheme(.dark)  // Modo oscuro
        }
    }
}

#Preview {
    LoadView()
}
