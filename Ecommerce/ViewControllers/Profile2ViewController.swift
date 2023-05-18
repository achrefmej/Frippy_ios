

import UIKit
import DSKit
import DSKitFakery

class Profile2ViewController: DSViewController {
    
    let person = DSFaker().person
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Personal user Data"
        update()
    }
    
    /// Update current content on the screen
    func update() {
        self.show(content: [getProfileDescription(), getPersonalDetailsSection()])
    }
}

// MARK: - Personal details form
extension Profile2ViewController {
    
    /// Get profile description´
    /// - Returns: DSSection
    func getProfileDescription() -> DSSection {



      

        
        let userName = UserDefaults.standard.string(forKey: "firstName" )
        let email = UserDefaults.standard.string(forKey: "email")
        let image = UserDefaults.standard.string(forKey: "image")
        // Profile picture
        let picture = DSImageVM(imageUrl: URL(string: "http://localhost:6000/images/\(image!)"), height: .absolute(100), displayStyle: .circle)
        
        // Profile text
        let text = DSTextComposer(alignment: .center)
        text.add(type: .title1, text: userName!)
        text.add(type: .subheadline, text: email!)
        
        
        // Description
        var description = DSActionVM(composer: text)
        description.style.displayStyle = .default
        


        
        return [picture, description].list()
    }
    
}

// MARK: - Personal details form
extension Profile2ViewController {
    
    /// Personal details form
    /// - Returns: DSSection
    func getPersonalDetailsSection() -> DSSection {
        
        
        let adresse = UserDefaults.standard.string(forKey: "adresse" )
        let mobilenumber = UserDefaults.standard.string(forKey: "mobilenumber")
        let image = UserDefaults.standard.string(forKey: "image")
        let userID = UserDefaults.standard.string(forKey: "userId")
               
        // Phone
        let phone = DSTextFieldVM.phone(placeholder: mobilenumber!)
        phone.errorPlaceHolderText = "Example: 0x xxx xx xx"
        
        // City
        let city = DSTextFieldVM.addressCity(placeholder:adresse!)
        
        // Address
        let address = DSTextFieldVM.address(placeholder: adresse!)
        
        // Update
        var updateButton = DSButtonVM(title: "Update")
        var pasButton = DSButtonVM(title: "Password Update")
        
        var skipButton = DSButtonVM(title: "Skip", type: .link)
        skipButton.height = .absolute(20)
        skipButton.didTap = { _ in
            self.dismiss()
        }
        
    
        
        // Handle did tap on update button
        updateButton.didTap = { [unowned self] model in
            let phone = phone.text
            let adre = address.text
            
            guard let userID = userID else {
                print("Error: userID is nil")
                return
            }
            
            guard let url = URL(string: "http://localhost:6000/api/profile/\(userID)") else {
                print("Error: invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let parameters = [
                "mobilenumber": phone,
                "adresse": adre,
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
                                 UserDefaults.standard.set(adresse, forKey: "adresse")
                                 UserDefaults.standard.set(mobilenumber, forKey: "mobilenumber")
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
            
            // Check if current form present on the screen is valid
            self.isCurrentFormValid { isValid in
                if isValid {
                    self.showSuccessMessage()
                }
            }
        }
        
        
        pasButton.didTap = { [unowned self] model in
            
            // Check if current from present on the screen is valid
          
          
            self.present(vc: Profile3ViewController(), presentationStyle: .fullScreen)
                
          
        }
      
        
  
        
        
        return [DSSpaceVM(type: .custom(30)),  phone, city, address,pasButton, updateButton,skipButton].list()
    }
    
    /// Show success message
    func showSuccessMessage() {
        self.show(message: "Your profile was successfully updated", type: .success, timeOut: 2) {
            self.popToRoot()
        }
    }
    
}


// MARK: - SwiftUI Preview

import SwiftUI

struct Profile2ViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            let nav = DSNavigationViewController(rootViewController: Profile2ViewController())
            PreviewContainer(VC: nav, DarkLightAppearance()).edgesIgnoringSafeArea(.all)
        }
    }
}
