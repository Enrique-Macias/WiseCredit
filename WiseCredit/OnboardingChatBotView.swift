//
//  OnboardingChatBotView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/15/24.
//

import SwiftUI

struct OnboardingChatBotView: View {
    var onContinue: () -> Void // Closure que se ejecuta cuando el usuario hace clic en "Continuar"
    var body: some View {
        ZStack {
            // Color de fondo azul
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                // Título principal
                Text("Asistente Financiero")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(.black)
                    .frame(width: 410, height: 31)
                    .padding()

                // Subtítulo
                Text("Acude a nuestro chat de asesoría para resolver dudas sobre procesos financieros")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 8)
                
                Spacer()

                // Botón Continuar
                Button(action: onContinue) {
                    ZStack {
                        Text("Continuar")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                            .foregroundColor(Color(.black))
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.right")
                                .font(.system(size: 18))
                                .foregroundStyle(Color(.black))
                        }
                        .padding(.trailing, 16)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(width: 330, height: 55)
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .cornerRadius(15)
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 40)
            }
        }
    }
}
