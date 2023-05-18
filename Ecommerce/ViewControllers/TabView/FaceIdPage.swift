//
//  FaceIdPage.swift
//  Frippy_finall
//
//  Created by Mac Mini 6 on 8/5/2023.
//


import SwiftUI

import LocalAuthentication





struct FaceIdPage: View {

    var body: some View {

        VStack {
            
            HStack {
                Button(action: {
                   

                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: TabBarView())
                            window.makeKeyAndVisible()
                        }
                }){
                    Image(systemName: "arrow.left")
                        .foregroundColor(.orange)
                }
                Spacer()
                Text("FaceID")
                    .font(Font.system(size: 16, weight: .bold, design: .rounded))
                Spacer()
            }
            Spacer()
            Image("faceid")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            Spacer()
            Button{
                faceIdHandle()
            } label: {
                Text("Confim")
                    .font(.system(size: 18).bold())
                    .padding(.vertical,15)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.white)
                    .background(Color.orange)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius:5,x: 5,y: 5)
            }
            .padding(.top,15)
            .padding(.horizontal)
            
            
            
        }
    }

func faceIdHandle(){

    let context = LAContext()

        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate with Face ID") { (success, error) in

                if success {
                        //  print("Authentication te5dem")
                    print("Authentication succeeded")
                     let alert = UIAlertController(title: "Authentication succeeded", message: nil, preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "OK", style: .default))
                     DispatchQueue.main.async {
                         UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                     }
                          
                          }else {

                    print("Authentication te5demch")



                    

                }

            }

        }else {

            print("Biometric authentication is not available")

            // Add your logic to handle biometric authentication not available

        }



    

 }

}





struct FaceIdPage_Previews: PreviewProvider {

    static var previews: some View {

        FaceIdPage()

    }

}
