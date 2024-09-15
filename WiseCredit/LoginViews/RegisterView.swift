//
//  RegisterView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/14/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var userIsLoggedIn = false
    @State private var errorMessage: String?

    // Firestore reference
    let db = Firestore.firestore()
    
    var body: some View {
        if userIsLoggedIn {
            ContentView() // Redirigir a ContentView si está logueado
        } else {
            content
        }
    }
    
    var content: some View {
        ZStack {
            Color("btBackground")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Main title
                Text("Registro")
                    .fontWeight(.bold)
                    .font(.system(size: 25))
                    .foregroundStyle(.primary)
                    .padding(.bottom, 22)
                
                // Name Field
                HStack {
                    Image(systemName: "person")
                        .foregroundStyle(.primary)
                        .frame(width: 20)
                    TextField("Nombre completo", text: $name)
                        .padding()
                        .foregroundStyle(.primary)
                        .frame(width: 280, height: 20)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                )
                .padding(.horizontal)
                
                // Email Field
                HStack {
                    Image(systemName: "envelope")
                        .foregroundStyle(.primary)
                        .frame(width: 20)
                    TextField("Correo electrónico", text: $email)
                        .keyboardType(.emailAddress)
                        .padding()
                        .foregroundStyle(.primary)
                        .frame(width: 280, height: 20)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                )
                .padding(.horizontal)
                
                // Password Field
                HStack {
                    Image(systemName: "lock")
                        .foregroundStyle(.primary)
                        .frame(width: 20)
                    SecureField("Contraseña", text: $password)
                        .padding()
                        .foregroundStyle(.primary)
                        .frame(width: 280, height: 20)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                )
                .padding(.horizontal)
                
                // Confirm Password Field
                HStack {
                    Image(systemName: "lock")
                        .foregroundStyle(.primary)
                        .frame(width: 20)
                    SecureField("Confirmar contraseña", text: $confirmPassword)
                        .padding()
                        .foregroundStyle(.primary)
                        .frame(width: 280, height: 20)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                )
                .padding(.horizontal)
                
                Spacer()
                
                // Botón de Registro
                Button {
                    register() // Ejecuta la función de registro
                } label: {
                    Text("Registrate")
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                        .frame(maxWidth: 340, minHeight: 55)
                        .background(colorScheme == .light ? Color.black : Color.white)
                        .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                // Mostrar mensaje de error
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
        }
    }
    
    // Función para Registrar
    func register() {
        if password != confirmPassword {
            errorMessage = "Las contraseñas no coinciden"
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let user = result?.user {
                // Guardar la información del usuario en Firestore
                saveUserToFirestore(userId: user.uid, email: user.email, name: name)
                withAnimation {
                    userIsLoggedIn = true
                    authViewModel.isUserLoggedIn = true
                    authViewModel.fetchUserName(userId: user.uid)
                }
            }
        }
    }
    
    // Guardar información del usuario en Firestore
    func saveUserToFirestore(userId: String, email: String?, name: String) {
        let userData: [String: Any] = [
            "userId": userId,
            "email": email ?? "",
            "name": name,
            "createdAt": Timestamp(date: Date())
        ]
        
        db.collection("users").document(userId).setData(userData) { error in
            if let error = error {
                self.errorMessage = "Error al guardar datos en Firestore: \(error.localizedDescription)"
            } else {
                print("Usuario guardado en Firestore con éxito.")
            }
        }
    }
}


#Preview {
    RegisterView().environmentObject(AuthViewModel())
}

