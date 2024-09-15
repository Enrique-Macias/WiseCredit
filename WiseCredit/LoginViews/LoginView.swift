//
//  LoginView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/14/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    let logoAnimationDelay: Double = 1.5
    let logoAnimationDuration: Double = 0.4
    let contentAnimationDuration: Double = 0.2
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showLogin = false
    @State private var showContent = false
    @State private var errorMessage: String?  // Mensaje de error si algo sale mal con el login
    @State private var showRegisterView = false  // Controla la presentación de RegisterView
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case username, password
    }
    
    let screen = UIScreen.main.bounds  // Asegura que esté dentro de la estructura
    
    var body: some View {
        ZStack {
            Color("btBackground")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("LogoBufetec")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screen.width * 0.5, height: screen.width * (showLogin ? 0.3 : 0.5))
                    .padding(.top, showLogin ? 50 : -40)
                    .foregroundStyle(.primary)
                    .animation(.spring(duration: logoAnimationDuration), value: showLogin)
                
                if showLogin {
                    VStack {
                        Spacer()
                        Image("bye")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 270)
                            .padding(.bottom, 30)
                        
                        Text("Iniciar sesión con correo")
                            .font(CustomFonts.PoppinsBold(size: 16))
                            .padding(.bottom, 20)
                        
                        Button {
                            focusedField = .username
                        } label: {
                            HStack {
                                Image(systemName: "envelope")
                                TextField("", text: $username, prompt: Text("Usuario").foregroundStyle(.gray).kerning(0))
                                    .font(.custom("Manrope-Bold", size: 16))
                                    .kerning(0.8)
                                    .fontWeight(.bold)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .keyboardType(.emailAddress)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(18)
                        .frame(width: screen.width * 0.9, height: 60, alignment: .leading)
                        .background(colorScheme == .dark ? Color.clear : Color.white)
                        .cornerRadius(16)
                        .foregroundStyle(.primary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                        )
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeIn(duration: contentAnimationDuration), value: showContent)
                        .focused($focusedField, equals: .username)
                        
                        ZStack {
                            Button(action: { focusedField = .password }) {
                                HStack {
                                    Image(systemName: "lock")
                                    if showPassword {
                                        TextField("", text: $password, prompt: Text("Contraseña").foregroundStyle(.gray).kerning(0))
                                            .autocapitalization(.none)
                                            .disableAutocorrection(true)
                                            .kerning(0.8)
                                            .font(.custom("Manrope-Medium", size: 16))
                                            .focused($focusedField, equals: .password)
                                            .multilineTextAlignment(.leading)
                                    } else {
                                        SecureField("", text: $password, prompt: Text("Contraseña").foregroundStyle(.gray).kerning(0))
                                            .autocapitalization(.none)
                                            .disableAutocorrection(true)
                                            .kerning(0.8)
                                            .font(.custom("Manrope-Medium", size: 16))
                                            .focused($focusedField, equals: .password)
                                            .multilineTextAlignment(.leading)
                                    }
                                    Spacer()
                                    
                                    Button(action: {
                                        showPassword.toggle()
                                    }) {
                                        Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                            .font(.system(size: 22))
                                            .foregroundColor(.primary)
                                            .opacity(0.5)
                                    }
                                    .padding(.trailing, 6)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(18)
                        .frame(width: screen.width * 0.9, height: 60, alignment: .leading)
                        .background(colorScheme == .dark ? Color.clear : Color.white)
                        .cornerRadius(16)
                        .foregroundStyle(.primary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.8)
                        )
                        .padding(.top, 10)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeIn(duration: contentAnimationDuration), value: showContent)
                        .focused($focusedField, equals: .password)
                        
                        Spacer()
                        
                        Button(action: {
                            login()  // Llamamos a la función de login
                        }) {
                            ZStack {
                                Text("Iniciar Sesión")
                                    .font(CustomFonts.PoppinsBold(size: 16))
                                    .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                            }
                            .frame(width: screen.width * 0.9, height: 60)
                            .background(colorScheme == .light ? Color.black : Color.white)
                            .cornerRadius(16)
                            .padding(.bottom, 10)
                        }
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeIn(duration: contentAnimationDuration), value: showContent)
                        
                        // Mensaje de error
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
                        
                        Button(action: {
                            // Acción para recuperación de contraseña
                        }) {
                            Text("Recuperar Contraseña")
                                .foregroundStyle(Color.black)
                                .font(CustomFonts.PoppinsMedium(size: 14))
                                .underline()
                        }
                        .padding(.top, 5)
                        
                        // Botón de "Regístrate" usando Button y presentando RegisterView como modal
                        HStack {
                            Text("No tienes una cuenta?")
                                .font(CustomFonts.PoppinsMedium(size: 14))
                                .foregroundColor(.primary.opacity(0.5))
                            
                            Button(action: {
                                showRegisterView = true
                            }) {
                                Text("Regístrate")
                                    .font(CustomFonts.PoppinsBold(size: 14))
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(.bottom, 50)
                        .padding(.top, 10)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeIn(duration: contentAnimationDuration), value: showContent)
                    }
                } else {
                    // Opción para mostrar una vista alternativa o EmptyView()
                    EmptyView()
                }
            }
            .frame(width: screen.width, height: screen.height)
            .edgesIgnoringSafeArea(.all)
            .transition(.opacity)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + logoAnimationDelay) {
                withAnimation(.spring(duration: logoAnimationDuration)) {
                    showLogin = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + logoAnimationDuration) {
                    withAnimation(.easeIn(duration: contentAnimationDuration)) {
                        showContent = true
                    }
                }
            }
        }
        // Presentamos RegisterView como modal
        .fullScreenCover(isPresented: $showRegisterView) {
            RegisterView()
                .environmentObject(authViewModel)
        }
    }
    
    // Función de login usando Firebase
    func login() {
        Auth.auth().signIn(withEmail: username, password: password) { result, error in
            if let error = error {
                // Mostrar el error si falla el inicio de sesión
                errorMessage = error.localizedDescription
            } else {
                // Si el login es exitoso, marcar la variable como "logueado"
                withAnimation {
                    authViewModel.isUserLoggedIn = true
                    authViewModel.fetchUserName(userId: Auth.auth().currentUser?.uid ?? "")
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthViewModel())
    }
}

