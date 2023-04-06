

import UIKit
import DSKit

open class ViewController: DSViewController {
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "E-Commerce"
        
        let login1 = DSActionVM(title: "Login 1") { [unowned self] action in
            self.present(vc: LogIn1ViewController(), presentationStyle: .fullScreen)
        }
        
     
        
        let logInSection = [login1].list()
        logInSection.subheadlineHeader("Login")
        

        
        let signUp2 = DSActionVM(title: "Sign Up 2") { [unowned self] action in
            self.present(vc: SignUp2ViewController(), presentationStyle: .fullScreen)
        }
        
     
        let Addshop = DSActionVM(title: "Sign Up 2") { [unowned self] action in
            self.present(vc: AddshopViewController(), presentationStyle: .fullScreen)
        }
        
        let signUpSection = [signUp2 ,Addshop].list()
        signUpSection.subheadlineHeader("Sign Up")
        
        let home1 = DSActionVM(title: "Home 1") { [unowned self] action in
            self.present(vc: Home1ViewController(), presentationStyle: .fullScreen)
        }
        
        let Shoppro = DSActionVM(title: "Home 1") { [unowned self] action in
            self.present(vc: ShopproViewController(), presentationStyle: .fullScreen)
        }
        
        
        
        let homeSection = [home1, Shoppro].list()
        homeSection.subheadlineHeader("Home")
        
   
        
        let categories3 = DSActionVM(title: "Categories 3") { [unowned self] action in
            self.present(vc: Categories3ViewController(), presentationStyle: .fullScreen)
        }
        
 
   
        let categoriesSection = [categories3].list()
        categoriesSection.subheadlineHeader("Categories")
        
      
        
    
    
        
        let items5 = DSActionVM(title: "Items 5") { [unowned self] action in
            self.push(Items5ViewController())
        }
        

  
        

        let itemsSection = [  items5].list()
        itemsSection.subheadlineHeader("Items")
        
        let search1 = DSActionVM(title: "Search 1") { [unowned self] action in
            self.presentInNavigationController(vc: Search1ViewController(), presentationStyle: .fullScreen)
        }
        
  
        let searchSection = [search1].list()
        searchSection.subheadlineHeader("Search")
        

        
        let itemDetails1 = DSActionVM(title: "Items Details 1") { [unowned self] action in
            self.push(ItemDetails1ViewController())
        }
        
     
        
        let itemDetailsSection = [itemDetails1].list()
        itemDetailsSection.subheadlineHeader("Items Details")
        

        
  
        
      
        
     
        
        let cart4 = DSActionVM(title: "Cart 4") { [unowned self] action in
            self.push(ItemsCart4ViewController())
        }
        
      
        
        let cartSection = [cart4].list()
        cartSection.subheadlineHeader("Cart")
        
      
        
        let aboutUs2 = DSActionVM(title: "About Us 2") { [unowned self] action in
            self.push(AboutUs2ViewController())
        }
        
        let aboutUs1Section = [aboutUs2].list()
        aboutUs1Section.subheadlineHeader("About Us")
        
        let feedback = DSActionVM(title: "Feedback 1") { [unowned self] action in
            self.present(vc: Feedback1ViewController(), presentationStyle: .formSheet)
        }
        
        let feedback1Section = [feedback].list()
        feedback1Section.subheadlineHeader("Feedback")
        
      
      
        
        let profileshop = DSActionVM(title: "Profile 2") { [unowned self] action in
            self.push(ProfileshopViewController())
        }
        let profile2 = DSActionVM(title: "Profile 2") { [unowned self] action in
            self.push(Profile2ViewController())
        }
        
        let profile3 = DSActionVM(title: "Profile 3") { [unowned self] action in
            self.push(Profile3ViewController())
        }
        
        let profileSection = [profile2, profile3, profileshop].list()
        profileSection.subheadlineHeader("Profile")
        

        
        let walktrought1 = DSActionVM(title: "Walktrought 1") { [unowned self] action in
            self.present(vc: Walktrought1ViewController(), presentationStyle: .overFullScreen)
        }
        
        let walktroughtSection = [walktrought1].list()
        walktroughtSection.subheadlineHeader("Walktrought")
        

        let imageGallery1 = DSActionVM(title: "Image Gallery 1") { [unowned self] action in
            self.present(vc: ImageGallery1ViewController(), presentationStyle: .fullScreen)
        }
        
 
        
        let imageGallerySection = [imageGallery1].list()
        imageGallerySection.subheadlineHeader("Image Gallery")
        
        let order3 = DSActionVM(title: "Order 3") { [unowned self] action in
            self.present(vc: Order3ViewController(), presentationStyle: .overFullScreen)
        }
        
     
        
        let orderSection = [order3].list()
        orderSection.subheadlineHeader("Order")
        
        let Addproduit = DSActionVM(title: "Addproduit") { [unowned self] action in
            self.present(vc: AddproduitViewController(), presentationStyle: .formSheet)
        }
        
        let AddproduitSection = [Addproduit].list()
        AddproduitSection.subheadlineHeader("Feedback")

        
        show(content: walktroughtSection,
             logInSection,
             signUpSection,
             homeSection,
             profileSection,
             imageGallerySection,
             feedback1Section,
             aboutUs1Section,
             cartSection,
             AddproduitSection,
             itemDetailsSection,
             orderSection,
             searchSection,
             itemsSection,
             categoriesSection
   
            )
    }
}
