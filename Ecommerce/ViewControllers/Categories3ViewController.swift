//
//  Categories3ViewController.swift
//  DSKit
//
//  Created by Borinschi Ivan on 02.03.2021.
//

import DSKit
import DSKitFakery

open class Categories3ViewController: DSViewController {
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        update()
    }
    
    func update() {
        show(content: categoriesSection())
    }
}

// MARK: - Categories

extension Categories3ViewController {
    
    /// Products gallery
    /// - Returns: DSSection
    func categoriesSection() -> DSSection {
        
        let shoes = category(title: "Start your own busniness",
                             description: "FROM ZERO TO HERO ",
                             image:  URL(string: "https://appinventiv.com/wp-content/uploads/sites/1/2022/09/mobile-app-for-ecommerce-startup.webp"))
       
        
        
        let shirts = categori(title: "Home",
                              description: "TAKE WITH US YOUR PRODUCT ",
                              image:  URL(string: "https://appinventiv.com/wp-content/uploads/sites/1/2022/09/mobile-app-for-ecommerce-startup.webp"))
        

                
        let section = [ shirts,  shoes].list()
        section.headlineHeader("Categories", size: 30)
        
        return section
    }
    
    func category(title: String, description: String, image: URL? = nil) -> DSViewModel {
        
        let composer = DSTextComposer(alignment: .center)
        
        composer.add(type: .text(font: .headlineWithSize(25), color: .white), text: title)
        composer.add(type: .text(font: .subheadline, color: .white), text: description)
        var card = DSCardVM(composer: composer, textPosition: .center, backgroundImage: .imageURL(url: image))
        card.height = .absolute(200)
        card.gradientTopColor = UIColor.black.withAlphaComponent(0.2)
        card.gradientBottomColor = UIColor.black.withAlphaComponent(0.5)
        card.didTap { [unowned self] (_:DSCardVM) in
       
            
            self.present(vc: AddshopViewController(), presentationStyle: .fullScreen)

        }
        
        return card
    }
    
    
    
    func categori(title: String, description: String, image: URL? = nil) -> DSViewModel {
        
        let composer = DSTextComposer(alignment: .center)
        
        composer.add(type: .text(font: .headlineWithSize(25), color: .white), text: title)
        composer.add(type: .text(font: .subheadline, color: .white), text: description)
        var card = DSCardVM(composer: composer, textPosition: .center, backgroundImage: .imageURL(url: image))
        card.height = .absolute(200)
        card.gradientTopColor = UIColor.black.withAlphaComponent(0.2)
        card.gradientBottomColor = UIColor.black.withAlphaComponent(0.5)
        card.didTap  { _ in
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: TabBarView())
                window.makeKeyAndVisible()
            }
        }
        
        return card
    }
    
    
}

// MARK: - SwiftUI Preview

import SwiftUI

struct Categories3ViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            PreviewContainer(VC: Categories3ViewController(), DarkLightAppearance()).edgesIgnoringSafeArea(.all)
        }
    }
}
