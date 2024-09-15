//
//  AuthViewModel.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/14/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var isUserLoggedIn: Bool = false
    @Published var userName: String = "" // Aquí almacenamos el nombre del usuario
    
    private var db = Firestore.firestore()

    init() {
        // Asegurarse de que Firebase esté configurado antes de verificar el estado
        DispatchQueue.main.async {
            self.checkUserLoginStatus()
        }
    }

    // Esta función verifica si el usuario está autenticado al iniciar la aplicación
    func checkUserLoginStatus() {
        if let user = Auth.auth().currentUser {
            self.isUserLoggedIn = true
            self.fetchUserName(userId: user.uid) // Llamamos a la función para obtener el nombre
        } else {
            self.isUserLoggedIn = false
        }
    }

    // Función para obtener el nombre del usuario desde Firestore
    func fetchUserName(userId: String) {
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                if let name = document.data()?["name"] as? String {
                    DispatchQueue.main.async {
                        self.userName = name
                    }
                }
            } else {
                print("No se pudo obtener el nombre del usuario: \(error?.localizedDescription ?? "Error desconocido")")
            }
        }
    }

    // Esta función se llama al iniciar sesión
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Error al iniciar sesión: \(error.localizedDescription)")
            } else if let user = result?.user {
                DispatchQueue.main.async {
                    self?.isUserLoggedIn = true
                    self?.fetchUserName(userId: user.uid) // Obtener el nombre del usuario después de iniciar sesión
                }
            }
        }
    }

    // Esta función se llama al registrar un nuevo usuario
    func register(email: String, password: String, name: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Error al registrarse: \(error.localizedDescription)")
            } else if let user = result?.user {
                // Guardar el nombre del usuario en Firestore después del registro
                self?.db.collection("users").document(user.uid).setData(["name": name]) { error in
                    if let error = error {
                        print("Error al guardar el nombre en Firestore: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            self?.isUserLoggedIn = true
                            self?.userName = name // Asignar el nombre localmente después de registrarse
                        }
                    }
                }
            }
        }
    }
}
