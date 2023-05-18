import SwiftUI
struct boutique :Decodable , Identifiable{
    var id : String {_id}
    var _id : String
    var client : String
    var nom: String
    var adresse: String
    var image: String?
    var linkSocialmedia: String?
    var brandemail: String?
    var numtelf: String?
    
    
    
}
