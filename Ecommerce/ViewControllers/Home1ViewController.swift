

import DSKit
import DSKitFakery

open class Home1ViewController: DSViewController {
    
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
        action.rightRoundImage(url: URL(string: "https://img.icons8.com/color/512/instagram-reel.png"), size: CGSize(width: 40, height: 40))
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
        
        var shop = newArrival(title: "naimi store", description: "ariena soghr best price ", image: "store")
        shop.didTap { [unowned self] (_ : DSActionVM) in
            self.present(vc: Items5ViewController(), presentationStyle: .fullScreen)
        }
        var shop1 = newArrival(title: "mejri store", description: "ariena soghr best price", image: "store2")
        shop1.didTap { [unowned self] (_ : DSActionVM) in
            self.present(vc: Items5ViewController(), presentationStyle: .fullScreen)
        }
        var shop2 = newArrival(title: "king Shoes ", description: "ariena soghr best price", image: "store4")
        shop2.didTap { [unowned self] (_ : DSActionVM) in
            self.present(vc: Items5ViewController(), presentationStyle: .fullScreen)
        }
        var shop3 = newArrival(title: "best Watches", description: "ariena soghr best price", image: "store5")
        shop3.didTap { [unowned self] (_ : DSActionVM) in
            self.present(vc: Items5ViewController(), presentationStyle: .fullScreen)
        }
        var shop4 = newArrival(title: "king for king", description: "ariena soghr best price", image: "store2")
        shop4.didTap { [unowned self] (_ : DSActionVM) in
            self.present(vc: Items5ViewController(), presentationStyle: .fullScreen)
        }
        var shop5 = newArrival(title: "best store", description: "ariena soghr best price", image: "store5")
        shop5.didTap { [unowned self] (_ : DSActionVM) in
            self.present(vc: Items5ViewController(), presentationStyle: .fullScreen)
        }
        
        let section = [shop, shop1, shop2, shop3, shop4, shop5].grid()
        section.header = header
        return section
    }
    

    func newArrival(title: String, description: String, image:String) -> DSViewModel {
        
        let composer = DSTextComposer(alignment: .natural)
        composer.add(type: .headlineWithSize(15), text: title)
        composer.add(type: .subheadlineWithSize(12), text: description)
        
        var action = composer.actionViewModel()
        action.topImage(image: UIImage(named: image),height: .unknown, contentMode: .scaleAspectFill)
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
            PreviewContainer(VC: Home1ViewController(), BlackToneAppearance()).edgesIgnoringSafeArea(.all)
        }
    }
}
