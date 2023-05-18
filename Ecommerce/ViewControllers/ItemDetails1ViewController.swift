

import DSKit
import DSKitFakery

open class ItemDetails1ViewController: DSViewController {
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Details"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backButton
        
        // Filter
        let share = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                    style: .plain,
                                    target: self,
                                    action: #selector(shareAction))
        
        // Sort
        let wishlist = UIBarButtonItem(image: UIImage(systemName: "text.badge.plus"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(wishList))
        
        navigationItem.rightBarButtonItems = [ share, wishlist]
        
        update()
    }
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func shareAction() {
        self.present(vc: Items5ViewController(), presentationStyle: .fullScreen)
    }
    
    @objc func likeAction() {
        self.dismiss()
    }
    
    @objc func wishList() {
        self.dismiss()
    }
    
    func update() {
        
        // Show content
        show(content: [pictureSection(),
                       productInfoSection(),
                       priceSection(),
                      
                       descriptionSection()])
        
        // Add to cart button
        let addToCart = DSButtonVM(title: "Add to cart", icon: UIImage(systemName: "cart.fill")) { [unowned self] tap in
            let prodnom = UserDefaults.standard.string(forKey: "prodnom")
            let descprod = UserDefaults.standard.string(forKey: "descprod")
            let priceString = UserDefaults.standard.string(forKey: "prixprod")
            let imageprod = UserDefaults.standard.string(forKey: "imageprod")
            let quantite = UserDefaults.standard.string(forKey: "prodnom")
            let userID = UserDefaults.standard.string(forKey: "userId")
            
     
                guard let url = URL(string: "http://localhost:6000/panier/addpanier") else {
                                print("Error: invalid URL")
                                return
                            }
                var request = URLRequest(url: url)
                          request.httpMethod = "POST"
                          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                          let parameters = [
                              "nom": prodnom ?? "",
                              "prix": priceString ?? "",
                              "quantiteProduit": quantite ?? "",
                              "image": imageprod ?? "" ,
                              "client":userID!
                          ]
                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
                       
                       let task = URLSession.shared.dataTask(with: request) { data, response, error in
                           guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                               print("Error:", error ?? "Unknown error")
                               return
                           }
                           
                           if response.statusCode == 200 {
                               do {
                                   if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any], let paniers = json["paniers"] as? [String:Any] {
                                      
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
                self.present(vc: ItemsCart4ViewController(), presentationStyle: .fullScreen)
            }
        var skipButton = DSButtonVM(title: "Skip", type: .link)
        skipButton.height = .absolute(20)
        skipButton.didTap = { _ in
            self.dismiss()
        }
        // Show bottom content
        showBottom(content: [addToCart, skipButton])
    }
}
func addcart(client: String, nom: String, prix: String, quantiteproduit: String, image: UIImage, completion: @escaping (Error?) -> Void) {
    // Convert the selected image to a Data object
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to Data"])
        completion(error)
        return
    }
    
    // Create a boundary string for the multipart form-data request
    let boundary = UUID().uuidString
    
    // Create the request object and set its method and headers
    var request = URLRequest(url: URL(string: "http://localhost:6000/panier/addpanier")!)
    request.httpMethod = "POST"
    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    var body = Data()
    
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"nom\"\r\n\r\n".data(using: .utf8)!)
    body.append("\(client)\r\n".data(using: .utf8)!)
    
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"brandemail\"\r\n\r\n".data(using: .utf8)!)
    body.append("\(nom)\r\n".data(using: .utf8)!)
    
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"adresse\"\r\n\r\n".data(using: .utf8)!)
    body.append("\(prix)\r\n".data(using: .utf8)!)
    
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"client\"\r\n\r\n".data(using: .utf8)!)
    body.append("\(quantiteproduit)\r\n".data(using: .utf8)!)
    
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    body.append(imageData)
    
    body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    
    // Set the request body and content length
    request.httpBody = body
    request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
    
    // Create a URLSessionDataTask to perform the request
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(error)
            return
        }

        guard let data = data else {
            
            let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned from server"])
            
            completion(error)
            
            return
            
        }
        
    }
    
    task.resume()
    completion(nil)
}
// MARK: - Sections
extension ItemDetails1ViewController {
    
    /// Product info section
    /// - Returns: DSSection
    func productInfoSection() -> DSSection {
        let prodnom = UserDefaults.standard.string(forKey: "prodnom")
        let quantite = UserDefaults.standard.string(forKey: "prodnom")
       let  imageprod = UserDefaults.standard.string(forKey:"imageprod")
        let composer = DSTextComposer()
        composer.add(type: .title2, text: prodnom!)
        composer.add(type: .subheadline, text: quantite! )
        
        
        
        return [composer.textViewModel()].list().zeroTopInset()
    }
    
   
    /// Price section
    /// - Returns: DSSection
   /* func skipSection() -> DSSection {
  
        var skipButton = DSButtonVM(title: "Skip", type: .link)
        skipButton.height = .absolute(20)
        skipButton.didTap = { _ in
            self.dismiss()
        }
         
            return DSSection()
        
    }*/

    func priceSection() -> DSSection {
        if let priceString = UserDefaults.standard.string(forKey: "prixprod") {
            let price = DSPrice(amount: priceString, currency: "DT")
            
            // Text
            let text = DSTextComposer()
            text.add(price: price, size: .large, newLine: false)
            
            // Action
            var action = DSActionVM(composer: text)
            action.style.displayStyle = .default
            action.height = .absolute(30)
            
            return action.list()
        } else {
            return DSSection()
        }
    }
    
    
    
    
    /// Description
    /// - Returns: DSSection
    func descriptionSection() -> DSSection {
        let descprod = UserDefaults.standard.string(forKey: "descprod")

        let text = descprod!
        
        let label = DSLabelVM(.callout, text: text, alignment: .left)
        
        return [label].list()
    }
    
    /// Gallery section

    
    func pictureSection() -> DSSection {
         let imageUrlString = UserDefaults.standard.string(forKey: "imageprod")
             let imageUrl = URL(string: imageUrlString ?? "nil")
        let pictureModel = DSImageVM(imageUrl: imageUrl, height: .absolute(300), displayStyle: .themeCornerRadius)
        
        return pictureModel.list().zeroLeftRightInset()
    }

    
    
}

// MARK: - SwiftUI Preview

import SwiftUI

struct ItemDetails1ViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            let nav = DSNavigationViewController(rootViewController: ItemDetails1ViewController())
            PreviewContainer(VC: nav, DarkLightAppearance()).edgesIgnoringSafeArea(.all)
        }
    }
}

fileprivate let p1Image = URL(string: "https://www.cdiscount.com/pdt2/3/9/7/1/700x700/mp16215397/rw/sous-vetement-thermique-femme-doublure-laine-polai.jpg")
fileprivate let p2Image = URL(string: "https://www.cdiscount.com/pdt2/3/9/7/1/700x700/mp16215397/rw/sous-vetement-thermique-femme-doublure-laine-polai.jpg")
fileprivate let p3Image = URL(string: "https://www.cdiscount.com/pdt2/3/9/7/1/700x700/mp16215397/rw/sous-vetement-thermique-femme-doublure-laine-polai.jpg")
