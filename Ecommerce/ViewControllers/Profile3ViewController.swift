

import UIKit
import DSKit
import DSKitFakery

class Profile3ViewController: DSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Update Password"
        update()
    }
    
    /// Update current content on the screen
    func update() {
        self.show(content: [getFormSection()])
    }
}

// MARK: - Form section
extension Profile3ViewController {
    
    func getFormSection() -> DSSection {
        
        // Subtitle
        var description = DSLabelVM(.subheadline, text: "Changing your password regularly reduces your risk of exposure and avoids a number of dangers.")
        description.style.displayStyle = .grouped(inSection: false)
        
        var icon = DSImageVM(imageValue: .sfSymbol(name: "exclamationmark.shield.fill", style: .large), contentMode: .scaleAspectFit)
        icon.width = .absolute(30)
        icon.height = .absolute(30)
        
        icon.tintColor = .custom(UIColor.systemYellow)
        description.leftSideView = DSSideView(view: icon)
        
        // Password
        let currentPassword = DSTextFieldVM.password(placeholder: "Current Password")
   
        
        // Password
        let password = DSTextFieldVM.newPassword(placeholder: "Password")
       
        
        // Password
        let repeatPassword = DSTextFieldVM.newPassword(placeholder: "Repeat password")
        repeatPassword.errorPlaceHolderText = "Should match password"
        repeatPassword.handleValidation = { text in
            return text == password.text
        }
        let userID = UserDefaults.standard.string(forKey: "userId")

        // Update
        var updateButton = DSButtonVM(title: "Update")
        
        // Handle did tap on button
        updateButton.didTap = { [unowned self] model in
            self.present(vc: Profile2ViewController(), presentationStyle: .fullScreen)
            
            let currentPassword = currentPassword.text
            let password = password.text
            let repeatPassword = password
            
            guard let userID = userID else {
                print("Error: userID is nil")
                return
            }
            
            guard let url = URL(string: "http://localhost:6000/api/users/\(userID)") else {
                print("Error: invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let parameters = [
                "oldPassword": currentPassword,
                "newPassword": password,
                "confirmPassword":repeatPassword
              
            ]
            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                    print("Error:", error ?? "Unknown error")
                    return
                }
                if response.statusCode == 200 {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any], let user = json["user"] as? [String:Any] {
                            // Update values in UserDefaults
                              
                        } else {
                            print("Error: JSON response is missing or has the wrong format")
                        }
                    } catch {
                        print("Error:", error)
                    }
                } else {
                    print("Error: status code:", response.statusCode)
                }
            }
            task.resume()
            
            
            self.isCurrentFormValid { isValid in
                if isValid {
                    self.show(message: "Your password was successfully updated",
                              type: .success,
                              timeOut: 1) {
                        self.update()
                    }
                }
            }
            
        }
        
        return [description,
                currentPassword,
                password,
                repeatPassword,
                updateButton].list()
        
    }
}

// MARK: - SwiftUI Preview

import SwiftUI

struct Profile3ViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            let nav = DSNavigationViewController(rootViewController: Profile3ViewController())
            PreviewContainer(VC: nav, DarkLightAppearance()).edgesIgnoringSafeArea(.all)
        }
    }
}
