

import DSKit
import DSKitFakery

open class ItemDetails1ViewController: DSViewController {
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Details"
        

        
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
        show(content: [picturesGallerySection(),
                       productInfoSection(),
                       priceSection(),
                      
                       descriptionSection()])
        
        // Add to cart button
        let addToCart = DSButtonVM(title: "Add to cart", icon: UIImage(systemName: "cart.fill")) { [unowned self] tap in
            self.present(vc: ItemsCart4ViewController(), presentationStyle: .fullScreen)
        }
        
        // Show bottom content
        showBottom(content: addToCart)
    }
}

// MARK: - Sections
extension ItemDetails1ViewController {
    
    /// Product info section
    /// - Returns: DSSection
    func productInfoSection() -> DSSection {
        
        let composer = DSTextComposer()
        composer.add(type: .title2, text: "Women's Running Shoe")
        composer.add(type: .subheadline, text: "Nike Revolution 5")
        
        return [composer.textViewModel()].list().zeroTopInset()
    }
    
   
    /// Price section
    /// - Returns: DSSection
    func priceSection() -> DSSection {
        
        // Text
        let text = DSTextComposer()
        text.add(price: DSPrice.random(), size: .large, newLine: false)
        
        // Action
        var action = DSActionVM(composer: text)
        action.style.displayStyle = .default
        action.height = .absolute(30)
        
       
        
        
        
      
        
        return action.list()
    }
    
    /// Description
    /// - Returns: DSSection
    func descriptionSection() -> DSSection {
        
        let text = "The Nike Revolution 5 cushions your stride with soft foam to keep you running in comfort. Lightweight knit material wraps your foot in breathable support, while a minimalist design fits in anywhere your day takes you."
        
        let label = DSLabelVM(.callout, text: text, alignment: .left)
        
        return [label].list()
    }
    
    /// Gallery section
    /// - Returns: DSSection
    func picturesGallerySection() -> DSSection {
        
        let urls = [p1Image,
                    p2Image,
                    p3Image].compactMap({ $0 })
        
        let pictureModels = urls.map { url -> DSViewModel in
            return DSImageVM(imageUrl: url, height: .absolute(300), displayStyle: .themeCornerRadius)
        }
        
        let pageControl = DSPageControlVM(type: .viewModels(pictureModels))
        return pageControl.list().zeroLeftRightInset()
    }
}

// MARK: - SwiftUI Preview

import SwiftUI

struct ItemDetails1ViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            let nav = DSNavigationViewController(rootViewController: ItemDetails1ViewController())
            PreviewContainer(VC: nav, DSKitAppearance()).edgesIgnoringSafeArea(.all)
        }
    }
}

fileprivate let p1Image = URL(string: "https://www.cdiscount.com/pdt2/3/9/7/1/700x700/mp16215397/rw/sous-vetement-thermique-femme-doublure-laine-polai.jpg")
fileprivate let p2Image = URL(string: "https://www.cdiscount.com/pdt2/3/9/7/1/700x700/mp16215397/rw/sous-vetement-thermique-femme-doublure-laine-polai.jpg")
fileprivate let p3Image = URL(string: "https://www.cdiscount.com/pdt2/3/9/7/1/700x700/mp16215397/rw/sous-vetement-thermique-femme-doublure-laine-polai.jpg")
