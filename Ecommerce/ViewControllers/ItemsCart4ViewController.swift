

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
        var totalText = DSLabelVM(.title2, text: "Total")
        let forString = "for \(itemsCount) \(itemsCount.getCorrectForm(singular: "Items", plural: "Items")) "
        
        // Text
        let composer = DSTextComposer(alignment: .right)
        composer.add(type: .subheadline, text: forString)
        composer.add(price: DSPrice.random(min: 400, max: 700), size: .large, newLine: false)
        
        // Price
        let priceVM = composer.textViewModel()
        totalText.supplementaryItems = [priceVM.asSupplementary(position: .rightCenter, offset: .custom(.zero))]
        
        // Continue button
        var button = DSButtonVM(title: "Checkout", icon: UIImage(systemName: "creditcard.fill"))
        button.didTap { [unowned self] (button: DSButtonVM) in
            self.present(vc: Order3ViewController(), presentationStyle: .fullScreen)
        }
        
        showBottom(content: [totalText, button].list())
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
    
    /// Products gallery
    /// - Returns: DSSection
    func productsSection() -> DSSection {
        
        // 1
        let product1 = product(title: "Armani Blouse",
                               description: "Color: Gray, size: M",
                               image: p1Image)
        
        // 2
        let product2 = product(title: "Dolce & Gabbana Dress",
                               description: "Color: Black, size: L",
                               image: p2Image)
        
        // 3
        let product3 = product(title: "Zara Blouse",
                               description: "Color: Red, size: L",
                               image: p3Image)
        
        // 4
        let product4 = product(title: "Dolce & Gabbana Dress",
                               description: "Apple Inc",
                               image: p4Image
                              )
        
        let section = [product1, product4, product3, product2].list()
        
        return section
    }
    
    /// Product
    /// - Parameters:
    ///   - title: String
    ///   - description: String
    ///   - image: URL?
    ///   - badge: String?
    /// - Returns: DSViewModel
    func product(title: String, description: String, image: URL? = nil, badge: String? = nil) -> DSViewModel {
        
        // Text
        let composer = DSTextComposer(alignment: .natural)
        composer.add(type: .headlineWithSize(16), text: title)
        composer.add(type: .subheadline, text: description)
        composer.add(price: DSPrice.random(), spacing: 5)
        
        // Action
        var action = composer.actionViewModel()
        action.leftImage(url: image, size: .size(.init(width: 100, height: 70)))

        
        action.rightButton(sfSymbolName: "minus.circle.fill",
                           style: .custom(size: 18, weight: .regular)) { [unowned self] in
            self.dismiss()
        }
        
        // Label
        if let badge = badge {
            action.supplementaryItems = [label(title: badge)]
        }
        
        // Handle did tap
        action.didTap { [unowned self] (_ :DSCardVM) in
            self.dismiss()
        }
        
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
            PreviewContainer(VC: nav, BlackToneAppearance()).edgesIgnoringSafeArea(.all)
        }
    }
}

fileprivate let p1Image = URL(string: "https://www.cdiscount.com/pdt2/3/9/7/1/700x700/mp16215397/rw/sous-vetement-thermique-femme-doublure-laine-polai.jpg")

fileprivate let p2Image = URL(string: "https://contents.mediadecathlon.com/m9022277/k$09c376fb8b1d6dbf758a266560bb965e/sq/333ba4f2-e50b-44df-a613-6cf5a71109d5_c1.jpg?format=auto&f=800x0")

fileprivate let p3Image = URL(string: "https://www.moment-cocooning.com/wp-content/uploads/2022/10/68046-cl4m6e.jpg")

fileprivate let p4Image = URL(string: "https://www.moment-cocooning.com/wp-content/uploads/2022/10/68046-cl4m6e.jpg")

