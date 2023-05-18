

import SwiftUI
struct produit :Decodable , Identifiable{
    var id : String {_id}
    var _id : String
    var produit: String?
    var quantite: String
    var prix: String
    var created_at: String
    var description: String
    var client: String
    var boutique: String

    
    var image: String?
    
    
}
