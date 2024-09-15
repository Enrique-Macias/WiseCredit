//
//  ProfileView.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/14/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("ProfileView")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color(.black))

            Button("Cerrar sesión") {
                do {
                    try Auth.auth().signOut()
                    withAnimation {
                        authViewModel.isUserLoggedIn = false
                    }
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(AuthViewModel())
    }
}
