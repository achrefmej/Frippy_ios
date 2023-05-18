//
//  Home.swift
//  Autos
//
//  Created by iMac on 12/4/2023.
//

import SwiftUI

@available(iOS 14.0, *)
struct Home: View {
    @EnvironmentObject var sharedData: SharedDataViewModel
    @StateObject var homeData: HomeViewModel=HomeViewModel()
  
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    var body: some View {
            VStack{
                HStack{
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    TextField("Search...",text: .constant(""))
                        .disabled(true)
                }
                .padding(.vertical,12)
                .padding(.horizontal)
                .background(
                    Capsule()
                        .strokeBorder(Color.gray,lineWidth: 0.8))
                Text("Products")
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .font(.system(size: 20).bold())
                    .padding()
                
                ScrollView(.vertical,showsIndicators: false){
                    
                    LazyVGrid(columns: adaptiveColumns, spacing: 20){
                        ForEach(homeData.products){product in
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    ProductCardView(product: product)
                                }
                                .foregroundColor(.orange)
                       
                        }
                    }

                    
                }
                
                
            }.padding()
        }
    @ViewBuilder
    func ProductCardView(product:boutique)->some View{
        VStack (spacing: 0){
            ZStack{
                if sharedData.showDetailProduct{
                    Image("images")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                else{
                    Image("images").resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .frame(width: 150,height:150)
                .cornerRadius(20)
                .offset(y:-80)
                .padding(.bottom,-80)
            Text(product.nom)
                .font(.system(size:18))
                .fontWeight(.semibold)
                .padding(.bottom,10)
            
                
                
        }
        .padding(10)
        .padding(.top,80)
        .background(
            Color.gray.opacity(0.1).cornerRadius(20))
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            Home()
        } else {
            // Fallback on earlier versions
        }
    }
}
