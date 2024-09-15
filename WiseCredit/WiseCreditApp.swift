
//
//  WiseCreditApp.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/14/24.
//

import SwiftUI
import Firebase

@main
struct WiseCreditApp: App {
    @StateObject var authViewModel = AuthViewModel() // Crear instancia del ViewModel
    
    init() {
        FirebaseApp.configure() // Configurar Firebase
    }
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isUserLoggedIn {
                ContentView()
                    .environmentObject(authViewModel) // Pasar el ViewModel al entorno
            } else {
                LoginView()
                    .environmentObject(authViewModel) // Pasar el ViewModel al entorno
            }
        }
    }
}
