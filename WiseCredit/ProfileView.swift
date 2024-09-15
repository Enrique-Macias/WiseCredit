//
//  ProfileView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/14/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                // Color de fondo para toda la pantalla
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // Imagen del perfil y detalles del usuario
                    VStack {
                        Image("profile_picture")  // Imagen del perfil (usa el nombre de la imagen en tu proyecto)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 120, height: 120)
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                        
                        Text(authViewModel.userName)
                            .font(CustomFonts.PoppinsSemiBold(size: 24))
                            .foregroundColor(.black)
    
                    }
                    .padding(.top, 40)
                    
                    Divider()
                        .padding(.horizontal, 30)
                    
                    // Opciones del perfil
                    VStack(alignment: .leading, spacing: 30) {
                        ProfileOptionRow(iconName: "gearshape.fill", text: "Preferences")
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ProfileOptionRow(iconName: "lock.fill", text: "Account Security")
                            ProgressView(value: 0.8)  // Barra de progreso para la seguridad
                                .progressViewStyle(LinearProgressViewStyle(tint: .red))
                                .frame(width: 200)
                            Text("Excellent")
                                .font(CustomFonts.PoppinsMedium(size: 14))
                                .foregroundColor(.gray)
                                .padding(.leading, 35)
                        }
                        
                        ProfileOptionRow(iconName: "questionmark.circle.fill", text: "Customer Support")
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    // Botón de Logout
                    Button(action: {
                        signOut()  // Acción para cerrar sesión
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.square.fill")
                                .font(.title)
                                .foregroundColor(.black)
                            
                            Text("Logout")
                                .font(CustomFonts.PoppinsSemiBold(size: 16))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.bottom, 50)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Profile")
                            .font(CustomFonts.PoppinsMedium(size: 18))
                    }
                }
            }
        }
    }
    
    // Función para cerrar sesión
    func signOut() {
        do {
            try Auth.auth().signOut()
            withAnimation {
                authViewModel.isUserLoggedIn = false
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

// Estructura reutilizable para las opciones del perfil
struct ProfileOptionRow: View {
    var iconName: String
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title)
                .foregroundColor(.black)
            
            Text(text)
                .font(CustomFonts.PoppinsSemiBold(size: 16))
                .foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}
