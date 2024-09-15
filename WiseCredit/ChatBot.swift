//
//  ChatBot.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/15/24.
//

import SwiftUI
import Foundation
import GoogleGenerativeAI

enum ChatRole {
    case user
    case model
}

struct ChatMessage: Identifiable, Equatable {
    let id = UUID().uuidString
    var role: ChatRole
    var message: String
}

@Observable
class ChatBot {
    private var chat: Chat?
    private(set) var messages = [ChatMessage]()
    private var hiddenPrompts = [ModelContent]()
    private(set) var loadingResponse = false
    
    init() {
            // Aquí puedes añadir tus prompts iniciales
            hiddenPrompts = [
                ModelContent(role: "user", parts: "Hola, eres un asistente financiero de WiseCredit. Eres un aliado diseñado para ayudar a los clientes a alcanzar sus metas financieras y gestionar sus finanzas personales de manera más efectiva. Tu función es resolver cualquier duda que los clientes puedan tener sobre sus finanzas, desde explicar sus patrones de gasto hasta ofrecer recomendaciones personalizadas para mejorar su salud financiera. También analizas los registros de gastos de los clientes en la aplicación, les brindas predicciones sobre su futuro financiero y sugieres las mejores opciones para ahorrar, invertir o mejorar su historial crediticio.Tu objetivo es proporcionar apoyo continuo y relevante, ayudando a los clientes a tomar decisiones informadas que aseguren un futuro financiero más próspero. ¡Estás aquí para guiar y empoderar a cada cliente en su camino hacia una mejor gestión de sus recursos!"),
                ModelContent(role: "model", parts: "¡Hola! 👋 “Bienvenido a WiseCredit, tu asistente financiero personalizado. Como parte de nuestro compromiso con tu bienestar financiero, este chatbot está diseñado para ayudarte a gestionar tus finanzas personales de manera más efectiva. El bot de WiseCredit puede resolver tus dudas sobre cualquier aspecto relacionado con tus finanzas, desde entender tus gastos y analizar tus patrones de consumo, hasta brindarte recomendaciones personalizadas para mejorar tu salud financiera. Además, el asistente puede analizar tus registros de gastos en la aplicación y ofrecer predicciones sobre tu futuro financiero, sugiriendo las mejores opciones para ahorrar, invertir o mejorar tu historial crediticio. Nuestro objetivo es brindarte un apoyo continuo y relevante, ayudándote a tomar decisiones informadas para asegurar un futuro financiero más próspero. Si necesitas orientación, recomendaciones personalizadas o simplemente tienes alguna pregunta sobre tus finanzas, ¡estamos aquí para ayudarte!” Este prompt está diseñado para explicar de manera profesional y detallada las capacidades y objetivos del chatbot de WiseCredit, resaltando su enfoque en brindar asistencia personalizada y mejorar la experiencia financiera del cliente.")
            ]
        }
    
    func sendMessage(_ message: String) {
        loadingResponse = true
        
        if(chat == nil) {
            //let history: [ModelContent] = messages.map { ModelContent(role: $0.role == .user ? "user" : "model", parts: $0.message)}
            chat = GenerativeModel(name: "gemini-1.5-pro", apiKey: APIKey.default).startChat(history: hiddenPrompts)
        }
        
            // Add Users message to the list
        messages.append(.init(role:.user, message: message))
        
        Task {
            do {
                let response = try await chat?.sendMessage(message)
                
                loadingResponse = false
                
                guard let text = response?.text else {
                    messages.append(.init(role: .model, message: "Something went wrong, please try again."))
                    return
                }
                
                messages.append(.init(role: .model, message: text))
            }
            catch {
                loadingResponse = false
                messages.append(.init(role: .model, message: "Something went wrong, please try again."))
            }
        }
    }
}

// ChatBot Button in the lower-right corner
struct ChatBotButton: View {
    var body: some View {
        ZStack {
            // Outer border circle
            Circle()
                .stroke(Color("btBlue"), lineWidth: 4)
                .frame(width: 65, height: 65)
            
            // Inner filled circle
            Circle()
                .fill(Color("btBlue"))
                .frame(width: 55, height: 55)
            
            // Icon in the center
            Image("BOT-logo")
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
                .foregroundColor(.white)
        }
    }
}
