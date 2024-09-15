
//
//  NotificationsView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/15/24.
//

import SwiftUI

struct NotificationsView: View {
    let notificationsToday: [NotificationItem] = [
        NotificationItem(username: "BBVA", action: "ha subido su CAT a 24%", time: "Just Now", icon: "arrow.up.circle.fill", iconColor: .red),
        NotificationItem(username: "Santander", action: "ha bajado su tasa de interés a 10%", time: "2m", icon: "arrow.down.circle.fill", iconColor: .green),
        NotificationItem(username: "Banorte", action: "ofrece 12 meses sin intereses", time: "5m", icon: "creditcard.fill", iconColor: .blue),
        NotificationItem(username: "HSBC", action: "ha aprobado una compra por $500", time: "7h", icon: "checkmark.circle.fill", iconColor: .green),
        NotificationItem(username: "Citibanamex", action: "ha añadido una nueva tarjeta", time: "22h", icon: "plus.circle.fill", iconColor: .blue)
    ]

    let notificationsOlder: [NotificationItem] = [
        NotificationItem(username: "BBVA", action: "ha bajado su tasa de interés a 9.5%", time: "11:24 PM", icon: "arrow.down.circle.fill", iconColor: .green),
        NotificationItem(username: "Santander", action: "ha aprobado una compra por $1200", time: "8:13 PM", icon: "checkmark.circle.fill", iconColor: .green),
        NotificationItem(username: "Banorte", action: "ofrece 18 meses sin intereses", time: "8:10 PM", icon: "creditcard.fill", iconColor: .blue),
        NotificationItem(username: "HSBC", action: "ha añadido una nueva tarjeta", time: "5:20 PM", icon: "plus.circle.fill", iconColor: .blue)
    ]

    var body: some View {
        VStack {
            HStack {
                Text("Notifications")
                    .font(CustomFonts.PoppinsSemiBold(size: 20))
                    .padding()
                
                Spacer()

                Button(action: {
                    // Acción de limpiar notificaciones
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
                    Text("Today")
                        .font(CustomFonts.PoppinsMedium(size: 14))
                        .foregroundColor(.gray)
                        .padding(.horizontal)

                    ForEach(notificationsToday) { notification in
                        NotificationRow(notification: notification)
                    }

                    Text("12 September 2019")
                        .font(CustomFonts.PoppinsMedium(size: 14))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .padding(.top, 10)

                    ForEach(notificationsOlder) { notification in
                        NotificationRow(notification: notification)
                    }
                }
            }
            .padding(.top)
        }
        .padding(.bottom, 20)
        .padding(.horizontal)
    }
}

struct NotificationItem: Identifiable {
    let id = UUID()
    let username: String
    let action: String
    let time: String
    let icon: String
    let iconColor: Color
}

struct NotificationRow: View {
    let notification: NotificationItem

    var body: some View {
        HStack {
            Image(systemName: notification.icon)
                .font(.title2)
                .foregroundColor(notification.iconColor)
                .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                Text(notification.username)
                    .font(CustomFonts.PoppinsSemiBold(size: 16))
                    .foregroundColor(.black) +
                Text(" \(notification.action)")
                    .font(CustomFonts.PoppinsMedium(size: 16))
                    .foregroundColor(.black)
                
                Text(notification.time)
                    .font(CustomFonts.PoppinsMedium(size: 14))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}


#Preview {
    NotificationsView()
}
