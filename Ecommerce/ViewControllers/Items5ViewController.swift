

import DSKit
import DSKitFakery

open class Items5ViewController: DSViewController {
    
    var selectedFilter = "Jackets"
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        title = ""
        update()
        
        // Filter
        let filter = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down.circle.fill"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(openFilters))
        
        // Sort
        let sort = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle.fill"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(openSort))
        
        navigationItem.rightBarButtonItems = [filter, sort]
    }
    
    // Call every time some data have changed
    func update() {
        show(content: headerSection(), filtersSection(), productsSection())
    }
    
    @objc func openFilters() {
        self.dismiss()
    }
    
    @objc func openSort() {
        self.dismiss()
    }
}

// MARK: - Header

extension Items5ViewController {
    
    // Header section
    func headerSection() -> DSSection {
        
        // Text
        let composer = DSTextComposer(alignment: .center)
        composer.add(type: .headlineWithSize(30), text: "Mejri store")
        composer.add(type: .headlineWithSize(12), text: "20 items")
        
        // Card with text
        var card = DSCardVM(composer: composer, textPosition: .center, backgroundImage: .imageURL(url: p0Image))
        card.height = .absolute(150)
        
        // Card gradient
        card.gradientTopColor = UIColor.white.withAlphaComponent(0.2)
        card.gradientBottomColor = UIColor.white.withAlphaComponent(0.3)
        
        return card.list()
    }
}

// MARK: - Products

extension Items5ViewController {
    
    /// Products
    /// - Returns: DSSection
    func productsSection() -> DSSection {
        
        // 1
        var product1 = product(title: "The Iconic Mesh Polo Shirt - All Fits",
                               description: "Polo Ralph Lauren",
                               image: p1Image)
        product1.didTap { [unowned self] (_ : DSActionVM) in
          self.present(vc: ItemDetails1ViewController(), presentationStyle: .fullScreen)
      }
      
      
        
        // 2
        var product2 = product(title: "Big Pony Mesh Polo Shirt",
                               description: "Stella McCarthney",
                               image: p2Image)
        
        
        
        product2.didTap { [unowned self] (_ : DSActionVM) in
          self.present(vc: ItemDetails1ViewController(), presentationStyle: .fullScreen)
      }
        
        // 3
        var product3 = product(title: "Mesh Long-Sleeve Polo Shirt – All Fits",
                               description: "Dolce & Gabbana",
                               image: p3Image)
        
        product3.didTap { [unowned self] (_ : DSActionVM) in
          self.present(vc: ItemDetails1ViewController(), presentationStyle: .fullScreen)
      }
        
        
        // 4
        var product4 = product(title: "Soft Cotton Polo Shirt - All Fits",
                               description: "Hermes",
                               image: p4Image)
        product4.didTap { [unowned self] (_ : DSActionVM) in
          self.present(vc: ItemDetails1ViewController(), presentationStyle: .fullScreen)
      }
        // 5
        var product5 = product(title: "Big Pony Mesh Polo Shirt",
                               description: "Arrmani",
                               image: p5Image)
        product5.didTap { [unowned self] (_ : DSActionVM) in
          self.present(vc: ItemDetails1ViewController(), presentationStyle: .fullScreen)
      }
        // 6
        var product6 = product(title: "Polo Team Mesh Polo Shirt",
                               description: "House & Versace",
                               image: p6Image)
        product6.didTap { [unowned self] (_ : DSActionVM) in
          self.present(vc: ItemDetails1ViewController(), presentationStyle: .fullScreen)
      }
        // 7
        var product7 = product(title: "Polo Team Mesh Polo Shirt",
                               description: "House & Versace",
                               image: p7Image)
        product7.didTap { [unowned self] (_ : DSActionVM) in
          self.present(vc: ItemDetails1ViewController(), presentationStyle: .fullScreen)
      }
        let section = [product1, product2, product4, product5, product6, product7, product3].grid()
        
        return section
    }
    

    func product(title: String, description: String, image: URL? = nil) -> DSViewModel {
        
        // Text
        let composer = DSTextComposer(alignment: .natural)
        composer.add(type: .headlineWithSize(14), text: title)
        composer.add(type: .subheadline, text: description)
       composer.add(price: DSPrice.random())
        
        // Action
        var action = composer.actionViewModel()
        action.topImage(url: image)
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
    func filtersSection() -> DSSection {
        
        let filters = ["Homme", "femme", "enfant", "bebe", "Montres", "produit beaute"]
        
        let viewModels = filters.map { (filter) -> DSViewModel in
            filterModel(title: filter)
        }
        
        let section = viewModels.gallery()
        return section
    }
    
  
    func filterModel(title: String) -> DSViewModel {
        
        // Is selected
        let selected = title == self.selectedFilter
        
        // Text
        let composer = DSTextComposer(alignment: .center)
        composer.add(type: .headlineWithSize(14), text: title)
        
        // Action
        var filter = composer.actionViewModel()
        
        filter.height = .absolute(35)
        
        // Selected style
        if selected {
            
            // Create a copy of colors from secondaryView colors
            var colors = DSAppearance.shared.main.secondaryView
            
            // Change the colors
            colors.background = colors.button.background
            colors.text.headline = colors.button.title
            colors.text.subheadline = colors.button.title
            
            // Set custom colors to filter
            filter.style.colorStyle = .custom(colors)
        }
        
        filter.width = .absolute(100)
        filter.style.displayStyle = .grouped(inSection: false)
        
        // Handle did tap
        filter.didTap { [unowned self] (_: DSActionVM) in
            self.selectedFilter = title
            self.update()
        }
        
        return filter
    }
}

// MARK: - SwiftUI Preview

import SwiftUI

struct Items5ViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            let nav = DSNavigationViewController(rootViewController: Items5ViewController())
            PreviewContainer(VC: nav, BlackToneAppearance()).edgesIgnoringSafeArea(.all)
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
