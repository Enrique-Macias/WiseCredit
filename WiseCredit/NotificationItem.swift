//
//  NotificationItem.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/15/24.
//

import FirebaseFirestore
import Combine
import SwiftUI

struct NotificationItem: Identifiable {
    var id: String  // El ID del documento
    var bankName: String
    var message: String
    var newRate: Double?
    var oldRate: Double?
    var timestamp: Timestamp
    
    // Campos adicionales si los hay
}
class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = []
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    init() {
        fetchNotifications()
    }
    
    func fetchNotifications() {
        listenerRegistration = db.collection("mensajes")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] querySnapshot, error in
                if let error = error {
                    print("Error al obtener las notificaciones: \(error.localizedDescription)")
                } else if let snapshot = querySnapshot {
                    print("Recibido snapshot con \(snapshot.documents.count) documentos.")
                    self?.notifications = snapshot.documents.compactMap { document in
                        let data = document.data()
                        let id = document.documentID
                        let bankName = data["bankName"] as? String ?? ""
                        let message = data["message"] as? String ?? ""
                        let newRate = data["newRate"] as? Double
                        let oldRate = data["oldRate"] as? Double
                        let timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
                        
                        return NotificationItem(
                            id: id,
                            bankName: bankName,
                            message: message,
                            newRate: newRate,
                            oldRate: oldRate,
                            timestamp: timestamp
                        )
                    

                    }
                } else {
                    print("Snapshot es nil.")
                }
            }
    }
    
    deinit {
        listenerRegistration?.remove()
    }
    
    // Método para limpiar notificaciones si es necesario
    func clearNotifications() {
        let batch = db.batch()
        for notification in notifications {
            let docRef = db.collection("mensajes").document(notification.id)
            batch.deleteDocument(docRef)
        }
        batch.commit { error in
            if let error = error {
                print("Error al eliminar las notificaciones: \(error.localizedDescription)")
            } else {
                print("Notificaciones eliminadas")
            }
        }
    }
}

