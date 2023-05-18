

import DSKit
import DSKitFakery
import UIKit




open class Home1ViewController: DSViewController {
    
    
    
    var sections: [DSSection] = []
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        update()

        
        
        
        
        
        
        
    }
    
    func update() {
        
        show(content: [userProfileSection(),
                       productsGallery(),
                       newArrivals()])
    }
}

// MARK: - User Profile

extension Home1ViewController {
    
    /// User profile section
    /// - Returns: DSSection
    func userProfileSection() -> DSSection {
        
        let composer = DSTextComposer()
        composer.add(type: .headlineWithSize(30), text: "Boutiques")
        composer.add(type: .subheadline, text: "Over 45 Boutiques available for you")
        
        var action = composer.actionViewModel()
        action.rightRoundImage(url: URL(string: "https://img.icons8.com/?size=512&id=M9iaNrWtUROf&format=png"), size: CGSize(width: 40, height: 40))
        action.didTap { [unowned self] (_ : DSActionVM) in
            self.present(vc: Profile2ViewController(), presentationStyle: .fullScreen)
        }
        action.style.displayStyle = .default
       
     // action.didTap { [unowned self] (_ :DSCardVM) in
        //  self.present(vc: Items5ViewController(), presentationStyle: .fullScreen)
       // }
        return action.list()
    }
    
    
}

// MARK: - Gallery

extension Home1ViewController {
    
    /// Products gallery
    /// - Returns: DSSection
    func productsGallery() -> DSSection {
        
        let sneakers =  DSImageVM(imageUrl: URL(string: "https://appinventiv.com/wp-content/uploads/sites/1/2022/09/mobile-app-for-ecommerce-startup.webp"), height: .absolute(200))
        let sneakers2 = DSImageVM(imageUrl: URL(string: "https://appinventiv.com/wp-content/uploads/sites/1/2022/09/mobile-app-for-ecommerce-startup.webp"), height: .absolute(200))
        let sneakers3 = DSImageVM(imageUrl:  URL(string: "https://appinventiv.com/wp-content/uploads/sites/1/2022/09/mobile-app-for-ecommerce-startup.webp"), height: .absolute(200))
        let pageControl = DSPageControlVM(type: .viewModels([sneakers, sneakers2, sneakers3]))
        
        return pageControl.list().zeroLeftRightInset()
    }
}

// MARK: - New arrivals

extension Home1ViewController {
    
    func fetchShops(completion: @escaping (Result<[boutique], Error>) -> Void) {
        guard let url = URL(string: "http://localhost:6000/boutique/allboutique") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
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
                let shops = try JSONDecoder().decode([boutique].self, from: data)
                //print("the shop \(shops)")
                completion(.success(shops))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    /// New arrivals
    /// - Returns: DSSection
    func newArrivals() -> DSSection {
        let composer = DSTextComposer()
        composer.add(type: .headline, text: "New Boutiques")
        var header = composer.actionViewModel()
        header.style.displayStyle = .default
        
        header.rightButton(title: "View all", sfSymbolName: "chevron.right", style: .medium) { [unowned self] in
            self.dismiss()
        }
        
        var shops: [DSViewModel] = []
        let group = DispatchGroup()
        group.enter()
        fetchShops { result in
            switch result {
            case .success(let boutiques):
                shops = boutiques.map { boutique in
                    var shopVM = self.newArrival(title: boutique.nom, description: boutique.adresse, image:boutique.image ?? "nil")
                  
                    shopVM.didTap { [unowned self] _ in
                        UserDefaults.standard.set(boutique._id, forKey: "idbrand")
                        UserDefaults.standard.set(boutique.client,forKey: "clientId")
                        UserDefaults.standard.set(boutique.nom, forKey: "selectedBoutiqueName")
                        UserDefaults.standard.set(boutique.adresse, forKey: "selectedBoutiqueAddress")
                        
                        self.present(vc: Items5ViewController(), presentationStyle: .fullScreen)
                    }
                    print(boutiques)
                    return shopVM
                    
                }
            case .failure(let error):
                print("Failed to fetch shops: \(error)")
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [self] in
            let section = shops.grid()
            section.header = header
            self.show(content: [userProfileSection(),
                                productsGallery(),section ])
        }
        
        let section = DSSection()
        return section
    }

    

    func newArrival(title: String, description: String, image:String) -> DSViewModel {
        
        let composer = DSTextComposer(alignment: .natural)
        composer.add(type: .headlineWithSize(15), text: title)
        composer.add(type: .subheadlineWithSize(12), text: description)
        
        var action = composer.actionViewModel()
        let urlImage = URL(string: image)
        action.topImage(url: urlImage,height: .unknown, contentMode: .scaleAspectFill)
        action.height = .absolute(180)
        action.style.displayStyle = .default
       
        action.didTap { [unowned self] (_:DSCardVM) in
       
            self.navigationController?.pushViewController(Search1ViewController(), animated: true)

        }
     
        return action
    }
}

// MARK: - SwiftUI Preview

import SwiftUI

struct Home1ViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            PreviewContainer(VC: Home1ViewController(), DarkLightAppearance()).edgesIgnoringSafeArea(.all)
        }
    }
}
