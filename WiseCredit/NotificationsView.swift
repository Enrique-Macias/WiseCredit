
//
//  NotificationsView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/15/24.
//

import SwiftUI
import FirebaseFirestore
import Firebase


struct NotificationsView: View {
    @ObservedObject var viewModel = NotificationsViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Notifications")
                    .font(CustomFonts.PoppinsSemiBold(size: 20))
                    .padding()
                
                Spacer()
                
                Button(action: {
                    // Acción de limpiar notificaciones
                    viewModel.clearNotifications()
                }) {
                    Text("Clear")
                        .font(CustomFonts.PoppinsMedium(size: 16))
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(groupedNotifications.keys.sorted(by: >), id: \.self) { dateKey in
                        Text(dateKey)
                            .font(CustomFonts.PoppinsMedium(size: 14))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                        ForEach(groupedNotifications[dateKey] ?? []) { notification in
                            NotificationRow(notification: notification)
                        }
                    }
                }
            }
            .padding(.top)
        }
        .padding(.bottom, 20)
        .padding(.horizontal)
    }
    
    // Agrupar notificaciones por fecha
    private var groupedNotifications: [String: [NotificationItem]] {
        Dictionary(grouping: viewModel.notifications) { notification in
            let date = notification.timestamp.dateValue()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: date)
        }
    }
    struct NotificationRow: View {
        let notification: NotificationItem
        
        var body: some View {
            HStack {
                Image(systemName: determineIcon(for: notification))
                    .font(.title2)
                    .foregroundColor(determineIconColor(for: notification))
                    .padding(.trailing, 8)
                
                VStack(alignment: .leading) {
                    (
                        Text(notification.bankName)
                            .font(CustomFonts.PoppinsSemiBold(size: 16))
                            .foregroundColor(.black) +
                        Text(" \(notification.message)")
                            .font(CustomFonts.PoppinsMedium(size: 16))
                            .foregroundColor(.black)
                    )
                    
                    Text(formatTimestamp(notification.timestamp))
                        .font(CustomFonts.PoppinsMedium(size: 14))
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        
        func formatTimestamp(_ timestamp: Timestamp) -> String {
            let date = timestamp.dateValue()
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .abbreviated
            return formatter.localizedString(for: date, relativeTo: Date())
        }
        
        func determineIcon(for notification: NotificationItem) -> String {
            // Lógica para determinar el ícono basado en el contenido de la notificación
            if let oldRate = notification.oldRate, let newRate = notification.newRate {
                if newRate > oldRate {
                    return "arrow.up.circle.fill"
                } else if newRate < oldRate {
                    return "arrow.down.circle.fill"
                } else {
                    return "circle.fill"
                }
            } else {
                return "bell.fill"
            }
        }
        
        func determineIconColor(for notification: NotificationItem) -> Color {
            // Lógica para determinar el color del ícono
            if let oldRate = notification.oldRate, let newRate = notification.newRate {
                if newRate > oldRate {
                    return .red
                } else if newRate < oldRate {
                    return .green
                } else {
                    return .gray
                }
            } else {
                return .blue
            }
        }
    }
}

#Preview {
    NotificationsView()
}
