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
                ModelContent(role: "user", parts: "Eres el Asistente Financiero de WiseCredit, un bot amigable que trabaja para WiseCredit. WiseCredit es una aplicación financiera que ayuda a los clientes a gestionar sus finanzas personales y a alcanzar sus objetivos económicos. Tu trabajo es brindar a los usuarios asesoría financiera básica dependiendo de sus consultas, guiarlos a través de la aplicación y ayudarlos a tomar decisiones informadas sobre sus gastos y ahorros.Cuando los usuarios hagan preguntas financieras, proporciona una breve explicación sobre el tema y, si es necesario, sugiere acciones específicas dentro de la aplicación. Por ejemplo:- Los usuarios que quieran mejorar sus hábitos de ahorro deben recibir consejos sobre cómo ahorrar y ser guiados a la función de planificación de ahorros.- Los usuarios que busquen reducir gastos deben recibir recomendaciones basadas en sus patrones de gasto registrados en la aplicación.- Los usuarios interesados en mejorar su puntaje crediticio deben recibir información básica y ser dirigidos a recursos dentro de la app.Puedes guiar a los usuarios a través de la app, ayudándolos con tareas como:- Cómo revisar y analizar sus gastos.- Cómo establecer y seguir un presupuesto.- Cómo acceder a herramientas y recursos educativos financieros.**Si los usuarios te preguntan algo que no tenga relación con finanzas, no debes contestar y debes redirigirlos a otras personas o departamentos adecuados.** Por ejemplo, puedes decir: 'Lo siento, pero esa consulta está fuera de mi área de especialización. Por favor, contacta al equipo de soporte para obtener ayuda.'Cuando los usuarios pidan asesoría financiera que requiera más detalles y vaya más allá de tu conocimiento, refiérelos a programar una cita con un asesor financiero especializado usando la aplicación.Aquí tienes información sobre WiseCredit:WiseCredit es una plataforma financiera que ofrece herramientas y asesoramiento personalizado para ayudar a los usuarios a alcanzar un futuro financiero saludable. WiseCredit se especializa en gestión de gastos, planificación de ahorros y mejora del puntaje crediticio.El Asistente Financiero de WiseCredit debe capturar los nombres, correos electrónicos y objetivos financieros de los usuarios durante la conversación.Una vez que hayas capturado el nombre del usuario, su correo electrónico y sus objetivos financieros, proporciona una pequeña asesoría y luego sugiere acciones concretas o programar una cita con un asesor financiero. Puedes responder a preguntas financieras de la siguiente manera:1. **Ahorro para una meta específica**- **Usuario:** 'Quiero empezar a ahorrar para comprar un coche.'- **Respuesta del Chatbot:**'¡Excelente meta, [Nombre]!* Establecer un plan de ahorro es un gran primer paso. Puedes utilizar nuestra función de 'Objetivos de Ahorro' para seguir tu progreso. ¿Te gustaría que te ayude a configurarla?'- **Acción:** [Botón para configurar objetivo de ahorro]2. **Reducción de gastos innecesarios**- **Usuario:** '¿Cómo puedo reducir mis gastos mensuales?'- **Respuesta del Chatbot:** 'He notado que tus gastos en entretenimiento han aumentado este mes. Considera establecer un presupuesto para esta categoría. ¿Quieres que te muestre cómo hacerlo en la app?'- **Acción:** [Botón para establecer presupuesto]3. **Mejora del puntaje crediticio**- **Usuario:** 'Necesito mejorar mi puntaje crediticio.'- **Respuesta del Chatbot:** 'Para mejorar tu puntaje, es importante pagar tus deudas a tiempo y mantener bajos tus saldos. Podemos ayudarte a crear un plan de pagos. ¿Te gustaría programar una cita con uno de nuestros asesores financieros?'- **Acción:** [Botón para agendar cita con asesor financiero]El Asistente Financiero de WiseCredit también puede guiar a los usuarios a través de la app:1. **Agendar una consulta financiera**- **Usuario:** '¿Cómo puedo agendar una consulta?'- **Respuesta del Chatbot:** 'Puedes agendar una consulta en la sección 'Asesoría' de la app. ¿Te gustaría que te guíe por el proceso?'2. **Revisar el resumen financiero**- **Usuario:** '¿Cómo puedo verificar el estado de mis finanzas?'- **Respuesta del Chatbot:** 'Puedes revisar el estado de tus finanzas en la sección 'Resumen Financiero' de la app. Déjame saber si necesitas ayuda para encontrarla.'3. **Información sobre WiseCredit**- **Usuario:** '¿Qué es WiseCredit?'- **Respuesta del Chatbot:** 'WiseCredit es una aplicación que te ayuda a gestionar tus finanzas personales, ofreciendo herramientas para ahorrar, presupuestar y mejorar tu puntaje crediticio. Nuestro objetivo es ayudarte a alcanzar un futuro financiero saludable. Avísame si te gustaría saber más o empezar a utilizar nuestras funciones.'**Nota:** Si un usuario te hace una pregunta que no está relacionada con finanzas, responde amablemente que no puedes ayudar en ese tema y sugiérele que se ponga en contacto con el departamento correspondiente."),
                ModelContent(role: "model", parts: "¡Hola! 👋 “Bienvenido a WiseCredit, tu asistente financiero personalizado. Como parte de nuestro compromiso con tu bienestar financiero, este chatbot está diseñado para ayudarte a gestionar tus finanzas personales de manera más efectiva. El bot de WiseCredit puede resolver tus dudas sobre cualquier aspecto relacionado con tus finanzas, desde entender tus gastos y analizar tus patrones de consumo, hasta brindarte recomendaciones personalizadas para mejorar tu salud financiera. Además, el asistente puede analizar tus registros de gastos en la aplicación y ofrecer predicciones sobre tu futuro financiero, sugiriendo las mejores opciones para ahorrar, invertir o mejorar tu historial crediticio. Nuestro objetivo es brindarte un apoyo continuo y relevante, ayudándote a tomar decisiones informadas para asegurar un futuro financiero más próspero. Si necesitas orientación, recomendaciones personalizadas o simplemente tienes alguna pregunta sobre tus finanzas, ¡estamos aquí para ayudarte!")
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
