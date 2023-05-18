import DSKit
import Foundation

open class LogIn1ViewController: DSViewController {
    let email = DSTextFieldVM.email(placeholder: "Email")
    let password = DSTextFieldVM.password(placeholder: "Password")

    open override func viewDidLoad() {
        super.viewDidLoad()
        showContent()
        showBottomContent()
    }

    /// Show content
    func showContent() {

        // Text
        let space1 = DSSpaceVM(type: .custom(50))
        let composer = DSTextComposer()
        composer.add(type: .headlineWithSize(38), text: "Welcome to\nFrippy")
        composer.add(type: .body, text: "An exciting place for the whole\nfamily to shop")
        let text = composer.textViewModel()
        let space2 = DSSpaceVM(type: .custom(50))
        let login = DSButtonVM(title: "Login") { [unowned self] (_: DSButtonVM) in
            guard let email = self.email.text,
                  let password = self.password.text else { return }
            // Make a network request to a Node.js server API
            
                let url = URL(string: "http://localhost:6000/api/signin")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let parameters = [
                    "email": email,
                    "password": password,
                ]
                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                        print("error", error ?? "Unknown error")
                        return
                    }
                    if response.statusCode == 200 {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                            let token = json["token"] as! String
                            let user = json["user"] as! [String:Any]
                            UserDefaults.standard.set(token, forKey: "token")
                            UserDefaults.standard.set(user["firstName"], forKey: "firstName")
                            UserDefaults.standard.set(user["email"],forKey: "email")
                            UserDefaults.standard.set(user["adresse"],forKey: "adresse")
                            UserDefaults.standard.set(user["mobilenumber"],forKey: "mobilenumber")
                            UserDefaults.standard.set(user["_id"], forKey: "userId")
                            UserDefaults.standard.set(user["image"], forKey: "image")
                            DispatchQueue.main.async{ 
                                if let window = UIApplication.shared.windows.first {
                                    window.rootViewController = UIHostingController(rootView: TabBarView())
                                    window.makeKeyAndVisible()
                                }
                            }
                            
                            
                            
                            
                        } catch {
                            print(error)
                        }
                    } else {
                        print("status code:", response.statusCode)
                    }
                }
                task.resume()
            }


        let forgotPassword = DSButtonVM(title: "Forgot password?", type: .link, textAlignment: .left) { [unowned self] (_: DSButtonVM) in
            self.dismiss()
        }

        let button = DSButtonVM(title: "G google", sfSymbol: "Google.fill") { _ in
            self.show(message: "Thank you for your feedback", type: .success) {
                self.dismiss()
            }
        }
        let buttonFace = DSButtonVM(title: "face", sfSymbol: "Google.fill")  { _ in
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: FaceIdPage())
                window.makeKeyAndVisible()
            }
        }
        let section = [space1, text, space2, email, password, login, button,buttonFace,forgotPassword].list()
        section.doubleMarginLeftRightInsets()

        // Show content
        show(content: section)
    }

    func showBottomContent() {

        var signUp = DSButtonVM(title: "Sign Up",
                                icon: DSSFSymbolConfig.buttonIcon("chevron.right"),
                                type: .secondaryView,
                                textAlignment: .left) { [unowned self] (_: DSButtonVM) in
            self.present(vc: SignUp2ViewController(), presentationStyle: .fullScreen)
        }

        signUp.imagePosition = .rightMargin

        // Show bottom content
        showBottom(content: [signUp].list().doubleMarginLeftRightInsets())
    }
}

// MARK: - SwiftUI Preview

import SwiftUI

struct LogIn1ViewControllerPreview: PreviewProvider {

    static var previews: some View {
       

            Group {
                PreviewContainer(VC: LogIn1ViewController(), DarkLightAppearance()).edgesIgnoringSafeArea(.all)
            }
        }
    }

