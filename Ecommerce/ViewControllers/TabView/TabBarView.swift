//
//  TabBarView.swift
//  ECommerceAppSwiftUI
//
//  Created by Ayush Gupta on 26/11/19.
//  Copyright © 2019 Ayush Gupta. All rights reserved.
//

import SwiftUI
import DSKit

struct TabBarView: View {
    @StateObject var searchlocationModel = LocationSearchModel()
    @State var selected = 0
    @State var searchtext = ""
    @StateObject var searchviewModel = LocationSearchModel()
    var body: some View {
        ZStack {
            Color.init("0xF56300")
                .edgesIgnoringSafeArea(.all)
            TabView(selection: $selected) {
                PreviewContainer(VC: Home1ViewController(), DarkLightAppearance())
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }.tag(0)
             //   PreviewContainer(VC: AddshopViewController(), DarkLightAppearance())
                ajout_shop()
                    .tabItem {
                        Image(systemName: "cart.fill")
                        Text("Shop")
                    }.tag(1)
                if #available(iOS 14.0, *) {
                    QRScannerPage()
                        .tabItem {
                            Image(systemName: "viewfinder.circle.fill")
                            Text("Scan QR")
                        }.tag(2)
                } else {
                    // Fallback on earlier versions
                }
                PreviewContainer(VC:  ItemsCart4ViewController(), DarkLightAppearance())
                          .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Cart")
                }
                .tag(3)
                PreviewContainer(VC:  Profile2ViewController(), DarkLightAppearance())
              //  SettingsView()
                    .tabItem {
                        Image(systemName: "ellipsis.circle.fill")
                        Text("Profile")
                    }.tag(4)
                
                
                //    PreviewContainer(VC: ItemsCart4ViewController(), DarkLightAppearance())
                    VStack {
                      
                            
                            

            
                        HStack(spacing: 10)
                        {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 22))
                                .foregroundColor(.gray)
                                .padding(.leading)
                            TextField("Search Place",text: $searchviewModel.queryFragment)
                                .padding(.vertical,10)
                                .padding(.horizontal)
                                .cornerRadius(15)
                                .padding()
                            
                            
                            
                        }.padding(.top,60)
                            .background(.white)
                        ScrollView(.vertical,showsIndicators: false,content: {
                            LazyVStack(alignment: .leading, spacing: 15,content: {
                                ForEach(searchviewModel.results, id:\.self){
                                    result in
                                    searchCell(title: result.title, subtitle: result.subtitle).onTapGesture {
                                        searchviewModel.selectLocation(result)
                                    }
                                }
                            })
                        }
                                   
                        )
                            .frame(height: 150)
                            .background(.white)
                           
                         MapView().ignoresSafeArea(.all)
                       
                    } .ignoresSafeArea(.all)
                    .tabItem {
                        Image(systemName: "Map.fill")
                        Text("Map")
                    }.tag(5)
                
            }
        }
        .accentColor(Color.init("0xFF9900"))
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
struct searchCell : View{
    let title :String
    let subtitle :String
    var body: some View
    {
        HStack
        {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundColor(.orange)
                .accentColor(.white)
                .frame(width: 40,height: 40)
            VStack(alignment: .leading)
            {
                Text(title)
                    .font(.body)
                Text(subtitle)
                    .font(.system(size:15))
                    .foregroundColor(.gray)
                Divider()
            }.padding(.leading ,8)
                .padding(.vertical ,8)
        }
        .padding(.leading)
    }
}
// A simple wrapper for a UIViewController
struct UIViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    let viewController: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No need to update anything here
    }
}
/*
// A simple UIViewController that embeds ScannerView in a UIHostingController
class ScannerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scannerView = ScannerView(scannedCode: .constant(nil))
        let hostingController = UIHostingController(rootView: scannerView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
    }
}*/


