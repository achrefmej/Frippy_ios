

import DSKit
import DSKitFakery
import UIKit
import SwiftUI
import CoreImage
open class Items5ViewController: DSViewController {
    
    var selectedFilter = "Jackets"
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        title = ""
        update()
        
        // Filter
      /*  let filter = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down.circle.fill"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(openFilters))
        */
    
        
        
        
        
        
        
        
        
    }
    
    // Call every time some data have changed
    func update() {
        show(content: headerSection(),categoriesSection(), categoriesSection1(),qrCodeSection(),product())
    }
    
    @objc func openFilters() {
        self.dismiss()
    }
    
    @objc func openSort() {
        
                let boutiqueName = UserDefaults.standard.string(forKey: "selectedBoutiqueName")

                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: TabBarView())
                    window.makeKeyAndVisible()
                }
        
    }
}





// MARK: - Header

extension Items5ViewController {
    
    // Header section
    func headerSection() -> DSSection {
       
       
       
       
        let boutiqueName = UserDefaults.standard.string(forKey: "selectedBoutiqueName")
        //  print(boutiqueName)
           let boutiqueAddress = UserDefaults.standard.string(forKey: "selectedBoutiqueAddress")
    
        // Text
        let composer = DSTextComposer(alignment: .center)
        composer.add(type: .headlineWithSize(30), text: boutiqueName! )
        composer.add(type: .headlineWithSize(12), text: boutiqueAddress! )
        
     
        
        // Card with text
        var card = DSCardVM(composer: composer, textPosition: .center, backgroundImage: .imageURL(url: p0Image))
        card.height = .absolute(150)
        
        // Card gradient
        card.gradientTopColor = UIColor.white.withAlphaComponent(0.2)
        card.gradientBottomColor = UIColor.white.withAlphaComponent(0.3)
        card.didTap  { _ in
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: TabBarView())
                window.makeKeyAndVisible()
            }
        }
        return card.list()
    }
    
}

// MARK: - Products

extension Items5ViewController {
    
    /// - Returns: DSSection
    func categoriesSection() -> DSSection {
        let userID = UserDefaults.standard.string(forKey: "userId")
        let client = UserDefaults.standard.string(forKey: "clientId")

        var actions: [DSViewModel] = []
        
        if userID == client {
            var addProduitAction = action(title: "Add Produit", leftSymbol: "rectangle.stack.fill.badge.person.crop")
            addProduitAction.didTap  { _ in
                let boutiqueID = UserDefaults.standard.string(forKey: "selectedBoutiqueID")
                let userID = UserDefaults.standard.string(forKey: "userId")
                let client = UserDefaults.standard.string(forKey: "clientId")
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: ajout_therapy())
                    window.makeKeyAndVisible()
                }
            }
            actions.append(addProduitAction)
        }

        let section = actions.list()
        section.subheadlineHeader("Settings")

        return section
    }

    func action(title: String, subtitle: String? = nil, leftSymbol: String? = nil) -> DSActionVM {
        return DSActionVM(title: title, subtitle: subtitle, leftSFSymbol: leftSymbol)
    }


    
    /// Products
    /// - Returns: DSSection
    func fetchShops(completion: @escaping (Result<[produit], Error>) -> Void) {
        let idbrand = UserDefaults.standard.string(forKey: "idbrand")

        guard let url = URL(string: "http://localhost:6000/produit/boutique/\(idbrand!)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            print(idbrand!)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let shops = try JSONDecoder().decode([produit].self, from: data)
                //print("the shop \(shops)")
                completion(.success(shops))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    /// New arrivals
    /// - Returns: DSSection
    func product() -> DSSection {
       
        
        var shops: [DSViewModel] = []
        let group = DispatchGroup()
        group.enter()
        fetchShops { result in
            switch result {
            case .success(let produits):
                shops = produits.map { produit in
                    var shopVM = self.product(title: produit.produit ?? "nil", description: produit.description, image:produit.image ?? "nil",price: "\(produit.prix)DT" )
                  
                    shopVM.didTap { [unowned self] _ in
                        UserDefaults.standard.set(produit.produit, forKey: "prodnom")
                        UserDefaults.standard.set(produit.description,forKey: "descprod")
                        UserDefaults.standard.set(produit.prix, forKey: "prixprod")
                        UserDefaults.standard.set(produit.quantite, forKey:"qprod")
                     
                        UserDefaults.standard.set(produit.image, forKey:"imageprod")
                        
                        self.present(vc: ItemDetails1ViewController(), presentationStyle: .fullScreen)
                    }
                    print(produits)
                    return shopVM
                    
                }
            case .failure(let error):
                print("Failed to fetch shops: \(error)")
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [self] in
            let section = shops.grid()
           
            self.show(content: [ headerSection(),categoriesSection(), categoriesSection1(),qrCodeSection(),
section ])
        }
        
        let section = DSSection()
        return section
    }

    

 
    

    func product(title: String, description: String, image:String ,price:String ) -> DSViewModel {
        
        // Text
        let composer = DSTextComposer(alignment: .natural)
        composer.add(type: .headlineWithSize(14), text: title)
        composer.add(type: .subheadline, text: description)
        composer.add(type: .headline, text : price)
        
        // Action
        var action = composer.actionViewModel()
        let urlImage = URL(string: image)
        action.topImage(url: urlImage )
        action.height = .absolute(290)

        
        // Like button
        action.supplementaryItems = [likeButton()]
     
        // Copy secondaryView colors and set as custom colors to picker
        let style = DSAppearance.shared.main.secondaryView
        let picker = DSQuantityPickerVM()
        picker.style.colorStyle = .custom(style)
        picker.quantityTextType = .subheadline
        picker.height = .absolute(20)
        
        // Picker right button
        picker.rightButton(sfSymbolName: "cart.fill.badge.plus", style: .custom(size: 18, weight: .medium)) { [unowned self] in
            self.present(vc: ItemDetails1ViewController(), presentationStyle: .fullScreen)
        }
        
        // Set picker as bottom side view to action
        action.bottomSideView = DSSideView(view: picker)
        
        // Handle did tap
        action.didTap { [unowned self] (_ :DSCardVM) in
            self.dismiss()
        }

        return action
    }
    
    /// Like button
    /// - Returns: DSSupplementaryView
    func likeButton() -> DSSupplementaryView {
        
        // Text
        let composer = DSTextComposer()
        composer.add(sfSymbol: "heart.fill",
                     style: .medium
                    // tint: .custom(Int.random(in: 0...1) == 0 ? .red : .white))
        )
        // Action
       var action = DSActionVM(composer: composer)
        
        // Handle did tap
        action.didTap { [unowned self] (_: DSActionVM) in
         
            self.dismiss()
        }
        
        // Supplementary view
        let supView = DSSupplementaryView(view: action,
                                          position: .rightTop,
                                          background: .lightBlur,
                                          insets: .small,
                                          offset: .interItemSpacing,
                                          cornerRadius: .custom(10))
      
        return supView
    }
}

// MARK: - Filters

extension Items5ViewController {
    
    /// Filter section
    /// - Returns: DSSection
    func categoriesSection1() -> DSSection {
        
        var map = action(title: " shop in map", leftSymbol: "map.fill")
        map.didTap{ _ in
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: ContentView())
                window.makeKeyAndVisible()
            }
            
        }
        var qrcode = action(title: " shop QRcode", leftSymbol: "viewfinder.circle.fill")
        qrcode.didTap{ _ in
            let boutiqueName = UserDefaults.standard.string(forKey: "selectedBoutiqueName")

            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: QrView())
                window.makeKeyAndVisible()
            }
            
        }
      
        let section = [map , qrcode ].list()
        section.subheadlineHeader("show boutique")
        
        
        return section
    }
    
  
  
}


//qrcode


extension Items5ViewController {
    
    func generateQRCodeImage(from boutiqueID: String) -> UIImage? {
        let data = boutiqueID.data(using: .utf8)
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        guard let outputImage = filter.outputImage else { return nil }
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    func qrCodeSection() -> DSSection {
        guard let boutiqueID = UserDefaults.standard.string(forKey: "selectedBoutiqueID") else { return DSSection() }
        guard let qrCodeImage = generateQRCodeImage(from: boutiqueID) else { return DSSection() }
        
        let imageView = UIImageView(image: qrCodeImage)
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        let section = DSSection()
        section.subheadlineHeader("Boutique QR Code")
        
        return section
    }


    
  
    
}








// MARK: - SwiftUI Preview



struct Items5ViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            let nav = DSNavigationViewController(rootViewController: Items5ViewController())
            PreviewContainer(VC: nav, DarkLightAppearance()).edgesIgnoringSafeArea(.all)
        }
    }
}

fileprivate let p0Image = URL(string: "https://images.pexels.com/photos/6417941/pexels-photo-6417941.jpeg?cs=srgb&dl=pexels-pavel-danilyuk-6417941.jpg&fm=jpg")
fileprivate let p1Image = URL(string: "https://www.cdiscount.com/pdt2/3/9/7/1/700x700/mp16215397/rw/sous-vetement-thermique-femme-doublure-laine-polai.jpg")
fileprivate let p2Image = URL(string: "https://contents.mediadecathlon.com/m9022277/k$09c376fb8b1d6dbf758a266560bb965e/sq/333ba4f2-e50b-44df-a613-6cf5a71109d5_c1.jpg?format=auto&f=800x0")
fileprivate let p3Image = URL(string: "https://www.moment-cocooning.com/wp-content/uploads/2022/10/68046-cl4m6e.jpg")
fileprivate let p4Image = URL(string: "https://m.media-amazon.com/images/I/51QmTYt59xL._AC_SX679_.jpg")
fileprivate let p5Image = URL(string: "https://www.cdiscount.com/pdt2/3/9/7/1/700x700/mp16215397/rw/sous-vetement-thermique-femme-doublure-laine-polai.jpg")
fileprivate let p6Image = URL(string: "https://m.media-amazon.com/images/I/51QmTYt59xL._AC_SX679_.jpg")
fileprivate let p7Image = URL(string: "https://www.cdiscount.com/pdt2/3/9/7/1/700x700/mp16215397/rw/sous-vetement-thermique-femme-doublure-laine-polai.jpg")
