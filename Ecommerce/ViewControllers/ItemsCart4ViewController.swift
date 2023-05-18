

import DSKit
import DSKitFakery

open class ItemsCart4ViewController: DSViewController {
    
    var itemsCount = 4
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Cart"
        update()
        
        // Filter
        let trash = UIBarButtonItem(image: UIImage(systemName: "trash.fill"),
                                    style: .plain,
                                    target: self,
                                    action: #selector(openFilters))
        
        navigationItem.rightBarButtonItems = [trash]
        
        updateTotalView()
    }
    
    // Call every time some data have changed
    func update() {
        show(content: productsSection())
    }
    
    /// Update total view
    func updateTotalView() {
      
        // Total label
       
    }
    
    @objc func openFilters() {
        self.dismiss()
    }
    
    @objc func openSort() {
        self.dismiss()
    }
}

// MARK: - Products

extension ItemsCart4ViewController {
    
    
    
    func fetchShops(completion: @escaping (Result<[panier], Error>) -> Void) {
 
        let userID = UserDefaults.standard.string(forKey: "userId")
        let prodnom = UserDefaults.standard.string(forKey: "prodnom")

        let descprod = UserDefaults.standard.string(forKey: "descprod")
        let priceString = UserDefaults.standard.string(forKey: "prixprod")
        let  imageprod = UserDefaults.standard.string(forKey:"imageprod")
     

        
           guard let url = URL(string: "http://localhost:6000/panier/\(userID!)") else {
               completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
               print(userID!)
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
                   let shops = try JSONDecoder().decode([panier].self, from: data)
                   //print("the shop \(shops)")
                   
                   completion(.success(shops))
               } catch {
                   completion(.failure(error))
               }
           }.resume()
       }
    
    /// Products gallery
    /// - Returns: DSSection
    func productsSection() -> DSSection {

        
        // 1
        /*let product1 = product(title: "Armani Blouse",
                               description: "Color: Gray, size: M",
                               image: p1Image)*/
        
        
              var shops: [DSViewModel] = []
              let group = DispatchGroup()
                var totalp: Float = 0.0

              group.enter()
              fetchShops { result in
                  switch result {
                  case .success(let paniers):
                      shops = paniers.map { panier in
                          var shopVM = self.product(title: panier.nom, description: panier.prix, image: panier.image ?? "nill")

                          // Delete button
                          var deleteButton = DSButtonVM( icon: UIImage(systemName: "trash"))
                          deleteButton.didTap { [unowned self] (button: DSButtonVM) in
                              deleteItem(withID: panier.id)
                          }
                          shopVM.supplementaryItems = [deleteButton.asSupplementary(position: .rightCenter, offset: .custom(.zero))]

                          return shopVM
                      }
                      totalp = paniers.map { Float($0.prix) ?? 0.0 }.reduce(0.0, +)
                      print("Total Price: \(totalp)")
            
                      

                  case .failure(let error):
                      print("Failed to fetch shops: \(error)")
                  }
                  group.leave()
              }
              
              group.notify(queue: .main) { [self] in
                  let section = shops.grid()
                  let total = shops.count
                  print(total)
                 
                  var totalText = DSLabelVM(.title2, text: "Total")
                  let forString = "for \(total) \(itemsCount.getCorrectForm(singular: "Items", plural: "Items")) "
                  
                  // Text
                  let composer = DSTextComposer(alignment: .right)
                  composer.add(type: .subheadline, text: forString)
                  let totp = String(totalp)
                  let pricet = DSPrice(amount: totp, currency: "DT")
                 
                  composer.add(price:pricet, size: .large, newLine: false)
             
                  
                  // Price
                  let priceVM = composer.textViewModel()
                  totalText.supplementaryItems = [priceVM.asSupplementary(position: .rightCenter, offset: .custom(.zero))]
                  
                  // Continue button
                  var button = DSButtonVM(title: "Checkout", icon: UIImage(systemName: "creditcard.fill"))
                  button.didTap { [unowned self] (button: DSButtonVM) in
                      self.present(vc: Order3ViewController(), presentationStyle: .fullScreen)
                  }
                  
                  showBottom(content: [totalText, button].list())
                  UserDefaults.standard.set(total, forKey: "items")
                 
                  self.show(content: [
      section ])
              }
              
              let section = DSSection()
              return section
          }
    private func deleteItem(withID id: String) {
        let urlString = "http://localhost:6000/panier/delete/\(id)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if let error = error {
                print("Failed to delete item: \(error)")
                return
            }

            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                print("Item deleted successfully")
                // Refresh the cart by refetching the data
                self.productsSection()
            } else {
                print("Failed to delete item")
            }
        }

        task.resume()
    }
    
    /// Product
    /// - Parameters:
    ///   - title: String
    ///   - description: String
    ///   - image: URL?
    ///   - badge: String?
    /// - Returns: DSViewModel
    func product(title: String, description: String, image:String, badge: String? = nil) -> DSViewModel {
        
        // Text
        let composer = DSTextComposer(alignment: .natural)
        composer.add(type: .headlineWithSize(16), text: title)
        composer.add(type: .subheadline, text: description)
   
        
        // Action
        var action = composer.actionViewModel()
        let urlImage = URL(string: image)
   
        action.leftImage(url: urlImage, size: .size(.init(width: 50, height: 50)))

      
        
        return action
    }
    
    /// Label supplementary view
    /// - Parameter title: String
    /// - Returns: DSSupplementaryView
    func label(title: String) -> DSSupplementaryView {
        
        let label = DSLabelVM(.headlineWithSize(10), text: title)
        
        let offset = appearance.groupMargins + 4
        
        let supView = DSSupplementaryView(view: label,
                                          position: .leftBottom,
                                          background: .primary,
                                          insets: .small,
                                          offset: .custom(.init(x: offset, y: offset)),
                                          cornerRadius: .custom(5))
        
        return supView
    }
}

// MARK: - SwiftUI Preview

import SwiftUI

struct ItemsCart4ViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            let nav = DSNavigationViewController(rootViewController: ItemsCart4ViewController())
            PreviewContainer(VC: nav, DarkLightAppearance()).edgesIgnoringSafeArea(.all)
        }
    }
}

fileprivate let p1Image = URL(string: "https://www.cdiscount.com/pdt2/3/9/7/1/700x700/mp16215397/rw/sous-vetement-thermique-femme-doublure-laine-polai.jpg")


