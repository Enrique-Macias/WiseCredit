//
//  MultiturnChatView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/15/24.
//

import SwiftUI

struct MultiturnChatView: View {
    @State var textInput = ""
    @State var logoAnimating = false
    @State var timer: Timer?
    @State var chatBot = ChatBot()
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                // Chat message list
                ScrollViewReader(content: { proxy in
                    ScrollView {
                        VStack {
                            Spacer(minLength: 200)
                            Image("edit-2")
                                .font(.system(size: 24))
                                .foregroundColor(Color(.black))
                                .padding(.bottom, 4)
                            
                            Text("Consulta de procedimientos")
                                .font(CustomFonts.PoppinsBold(size: 14))
                                .foregroundColor(Color(.black))
                                .padding(.bottom, 20)
                            
                            // Botones de preguntas predefinidas
                            VStack(spacing: 12) {
                                Button(action: {
                                    // Acción para la primera pregunta
                                }) {
                                    Text("¿Cómo se cuál es mi procedimiento legal?")
                                        .font(CustomFonts.PoppinsMedium(size: 14))
                                        .frame(maxWidth: .infinity, maxHeight: 15)
                                        .padding()
                                        .foregroundColor(.primary)
                                        .background(Color.clear)
                                        .cornerRadius(30)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(Color.primary, lineWidth: 1)
                                        )
                                }
                                
                                Button(action: {
                                    // Acción para la segunda pregunta
                                }) {
                                    Text("¿Que papelería debo tener a la mano?")
                                        .font(CustomFonts.PoppinsMedium(size: 14))
                                        .frame(maxWidth: .infinity, maxHeight: 15)
                                        .padding()
                                        .foregroundColor(.primary)
                                        .background(Color.clear)
                                        .cornerRadius(30)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(Color.primary, lineWidth: 1)
                                        )
                                }
                                
                                Button(action: {
                                    // Acción para la tercera pregunta
                                }) {
                                    Text("¿Cómo se cuál procedimiento tomar?")
                                        .font(CustomFonts.PoppinsMedium(size: 14))
                                        .frame(maxWidth: .infinity, maxHeight: 15)
                                        .padding()
                                        .foregroundColor(.primary)
                                        .background(Color.clear)
                                        .cornerRadius(30)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(Color.primary, lineWidth: 1)
                                        )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        ForEach(chatBot.messages) { chatMessage in
                            // Chat Message View
                            chatMessageView(chatMessage)
                        }
                    }
                    .onChange(of: chatBot.messages) { _, _ in
                        guard let recentMessage = chatBot.messages.last else { return }
                        DispatchQueue.main.async {
                            withAnimation {
                                proxy.scrollTo(recentMessage.id, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: chatBot.loadingResponse) { _, newValue in
                        if newValue {
                            startLoadingAnimation()
                        } else {
                            stopLoadingAnimation()
                        }
                    }
                })
                .background(Color.clear)
                
                Spacer()
                
                // Barra de ingreso de preguntas con TextField
                HStack {
                    TextField("Genera tu propia pregunta", text: $textInput)
                        .padding(10)
                        .foregroundColor(.secondary)
                        .background(Color.clear)
                        .cornerRadius(8)
                        .frame(height: 50)
                    
                    // Micrófono
                    Button(action: {
                        // Acción para grabar pregunta por voz (por implementar)
                    }) {
                        Image("microphone-2")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                    
                    // Botón de enviar pregunta
                    Button(action: {
                        sendMessage()
                    }) {
                        Image("send")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.black)
                            .padding(1)
                    }
                    .padding(.trailing, 10)
                }
                .frame(height: 55)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.primary, lineWidth: 1)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("arrow-left")
                            .font(.system(size: 20))
                            .foregroundColor(Color(.black))
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image("BOT-logo")
                            .font(CustomFonts.PoppinsBold(size: 20))
                            .foregroundColor(Color.black)
                            .opacity(logoAnimating ? 0.5 : 1)
                            .animation(.easeInOut, value: logoAnimating)
                        Text("Asistente")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color.black)
                            .opacity(logoAnimating ? 0.5 : 1)
                            .animation(.easeInOut, value: logoAnimating)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 15) {
                        Button(action: {
                            // Acción para sonido (por implementar)
                        }) {
                            Image("volume-high")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.black)
                        }
                        
                        Button(action: {
                            // Acción para recargar (por implementar)
                        }) {
                            Image("export")
                                .font(.system(size: 20))
                                .foregroundStyle(Color(.gray))
                        }
                    }
                }
            }
        }
    }
    
    // Chat Message View
    @ViewBuilder func chatMessageView(_ message: ChatMessage) -> some View {
        HStack {
            ChatBubble(direction: message.role == .model ? .left : .right) {
                Text(LocalizedStringKey(message.message))
                    .font(CustomFonts.PoppinsSemiBold(size: 14))
                    .padding(.all, 20)
                    .foregroundStyle(message.role == .model ? .primary : Color(.white))
                    .background(message.role == .model ? Color.clear : Color(.black))
                    .overlay(
                        // Aquí se ajusta el border personalizado para el chatbot
                        ChatBubbleShape(direction: message.role == .model ? .left : .right)
                            .stroke(Color(.black), lineWidth: 2) // Solo se aplica a los bordes necesarios
                    )
            }
        }
        .frame(maxWidth: .infinity, alignment: message.role == .model ? .leading : .trailing)
    }
    
    // Enviar mensaje
    func sendMessage() {
        chatBot.sendMessage(textInput)
        textInput = ""
    }
    
    // Animación de respuesta en espera
    func startLoadingAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            logoAnimating.toggle()
        })
    }
    
    func stopLoadingAnimation() {
        logoAnimating = false
        timer?.invalidate()
        timer = nil
    }
}

struct MultiturnChatView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MultiturnChatView()
                .preferredColorScheme(.light)
            MultiturnChatView()
                .preferredColorScheme(.dark)
        }
    }
}
