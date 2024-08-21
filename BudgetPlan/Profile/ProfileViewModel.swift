//
//  ProfileViewModel.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 20.08.2024..
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var userEmail: String = ""
    @Published var userImage: Image = Image(systemName: "person.circle")
    
    func loadUserProfile() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        self.userEmail = user.email ?? ""
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                if let data = document.data() {
                    self.firstName = data["firstName"] as? String ?? ""
                    self.lastName = data["lastName"] as? String ?? ""
                }
                if let photoUrlString = document.data()?["photoUrl"] as? String, let photoUrl = URL(string: photoUrlString) {
                    self.loadProfileImage(from: photoUrl)
                }
            } else {
                print("Document does not exist or error occurred: \(String(describing: error))")
            }
        }
    }
    
    private func loadProfileImage(from url: URL) {
        let storageRef = Storage.storage().reference(forURL: url.absoluteString)
        
        storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.userImage = Image(uiImage: uiImage)
                }
            } else {
                print("Error loading image: \(String(describing: error))")
            }
        }
    }
}
