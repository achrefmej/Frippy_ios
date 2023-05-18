import SwiftUI
struct panier :Decodable , Identifiable{
    var id : String {_id}
    var _id : String
    var client : String
    var nom: String
    var image: String?
    var prix: String
    var quantiteProduit:String
    //var Total : String
    
    
    
}
