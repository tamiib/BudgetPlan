import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .padding(.horizontal)
            .padding(.top, 20)
         
            ProfileView()
                .padding(.horizontal)
                .padding(.top, 10)
        
            AccountsView()
                .padding(.horizontal)
                .padding(.top, 10)
            
            Spacer()
            
            Button(action: {
                logOut()
            }) {
                Text("Log out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color("DarkBrownColor"))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .background(Color("BackgroundColor"))
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
            showSignInView = true 
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
}
