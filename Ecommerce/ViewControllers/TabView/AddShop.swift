


import SwiftUI

import MapKit

struct ajout_shop: View {
    
    
    
    
    
    
    
    let image  = UIImage (named: "Unknown")
    
    @State private var brandName: String = ""
    @State private var brandEmail: String = ""
    
    
    // by default it's empty
    
    
    @State private var adresse: String = "" // by default it's empty
    @State private var socialMediaLink: String = ""
    
    @State private var num: String = ""
    
    @State private var showingImagePicker = false
    
    
    
    @State private var quantity: Int = 0 // by default it's empty
    
    @State private var isOn = false
    
    
    @State private var selectedImage: UIImage?
    
    
    @State private var capacityText: String = ""
    
    @State private var selectedLocation: CLLocationCoordinate2D?
    
    
    
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    
    @State var isAdded = false
    
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    var body: some View {
       
 
        let userID = UserDefaults.standard.string(forKey: "userId")
    
        NavigationView{
        
            ScrollView {
                
                ZStack {
                    
                    
                    
                    VStack {
                        
                        
                        
                        HStack{
                            Button(action: {
                               

                                    if let window = UIApplication.shared.windows.first {
                                        window.rootViewController = UIHostingController(rootView: TabBarView())
                                        window.makeKeyAndVisible()
                                    }
                            }) {
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.orange)
                            }
                            Spacer()
                            Text("Add a shop")
                                .font(Font.system(size: 16, weight: .bold, design: .rounded))
                            Spacer()
                
                            
                            
                            
                        }
                        
                        HStack{
                            
                            if let image = self.selectedImage {
                                
                                Image(uiImage: image)
                                
                                    .resizable()
                                
                                    .scaledToFill()
                                
                                    .frame(width: 143,height: 143)
                                
                                    .cornerRadius(80)
                                
                            }else{
                                
                                
                                
                                Image("Unknown")
                                
                                    .resizable()
                                
                                    .scaledToFit()
                                
                                    .frame(width: 150)
                                
                                    .clipShape(Circle())
                                
                                    .shadow(radius: 10)
                                
                                
                                
                            }
                            
                            
                            
                        }
                        
                        .overlay(RoundedRectangle(cornerRadius: 80)
                                 
                            .stroke(.gray, lineWidth : 3)
                                 
                        )
                        
                        .onTapGesture {
                            
                            showingImagePicker.toggle()
                            
                        }
                        
                        .navigationViewStyle(StackNavigationViewStyle())
                        
                        .fullScreenCover(isPresented: $showingImagePicker, onDismiss: nil){
                            
                            ImagePicker(image: $selectedImage)
                            
                                .ignoresSafeArea()
                            
                        }
                        
                        .frame(width: 145,height: 145,alignment: .center)
                        
                        
                        
                        
                        
                        CaptionedTextField(caption: "brand Name", text: $brandName, placeholder: "Enter The brand Name")
                        
                            .padding([.top], 20)
                        CaptionedTextField(caption: "brand Email", text: $brandEmail, placeholder: "Enter The brand Email")
                        
                            .padding([.top], 20)
                        
                        
                        CaptionedTextField(caption: "adresse ", text: $adresse, placeholder: "Enter your adresse")
                        
                            .padding([.top], 20)
                        
                        
                        CaptionedTextField(caption: "social Media Link ", text: $socialMediaLink, placeholder: "Enter your social Media Link")
                        
                            .padding([.top], 20)
                        
                        CaptionedTextField(caption: "num ", text: $num, placeholder: "Enter your phone num")
                        
                            .padding([.top], 20)
                        
                        
             
                        
                        Spacer()
                        
                        
                        
             
                        
                        
                        
                        
                    }}
                
                Button(action: {
                    
                    Task {
                        
                        addshop( nom: brandName, brandemail: brandEmail,client: userID!,adresse:adresse,linkSocialmedia: socialMediaLink, numtelf: num, image: selectedImage!) { error in
                            
                            if let error = error {
                                
                                // Handle the error here
                                
                                print("Error adding : \(error.localizedDescription)")
                                
                            } else {
                                
                                // Success
                                
                                print(" added successfully!")
                                
                                isAdded = true
                                
                            }
                            
                            
                            
                        }}
                    
                }) {
                    
                    Text("Add Product")
                    
                    
                    
                    
                    
                        .font(.title3)
                    
                        .fontWeight(.bold)
                    
                        .foregroundColor( .white)
                    
                        .frame(height: 44)
                    
                        .padding(.horizontal, 30)
                    
                        .background(.orange)
                    
                        .cornerRadius(50)
                    
                }
                
                .background(
                    
                    NavigationLink(
                        
                        destination: EmptyView(),
                        
                        isActive: $isAdded,
                        
                        label: { EmptyView() }
                        
                    ))
                
                
                
            }
            
            
            
        }.navigationBarBackButtonHidden(true)
        
    }
    
    struct ajout_therapy_Previews: PreviewProvider {
        
        static var previews: some View {
            
            ajout_therapy().preferredColorScheme(.dark)
            
        }
        
    }
    
    
    struct ImagePicker : UIViewControllerRepresentable{
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
            
            
        }
        
        
        
        
        
        @Binding var image: UIImage?
        
        
        
        let ctr = UIImagePickerController()
        
        
        
        func makeCoordinator() -> Coordinator {
            
            return Coordinator(parent : self)
            
        }
        
        
        
        class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
        
        {
            
            
            
            let parent : ImagePicker
            
            
            
            init(parent: ImagePicker) {
                
                self.parent = parent
                
            }
            
            
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
                parent.image = info[.originalImage] as? UIImage
                
                picker.dismiss(animated: true)
                
            }
            
            
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                
                picker.dismiss(animated: true)
                
            }
            
            
            
        }
        
        
        
        func makeUIViewController(context: Context) -> some UIViewController {
            
            ctr.delegate = context.coordinator
            
            return ctr
            
        }
        
    }
    
    /*   addshop( nom: brandName, brandemail: brandEmail,client: userID!,adresse:adresse,linkSocialmedia: socialMediaLink, numtelf: num, image: selectedImage!)*/
    
    func addshop(nom: String, brandemail: String,client: String,adresse: String , linkSocialmedia: String,numtelf: String, image: UIImage, completion: @escaping (Error?) -> Void) {
        
        // Convert the selected image to a Data object
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            
            let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to Data"])
            
            completion(error)
            
            return
            
        }
        
        
        
        // Create a boundary string for the multipart form-data request
        
        let boundary = UUID().uuidString
        
        
        
        // Create the request object and set its method and headers
        
        var request = URLRequest(url: URL(string: "http://localhost:6000/boutique/addboutique")!)
        
        request.httpMethod = "POST"
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        /*   addshop( nom: brandName, brandemail: brandEmail,client: userID!,adresse:adresse,linkSocialmedia: socialMediaLink, numtelf: num, image: selectedImage!)*/
        // Create the request body as a Data object
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"nom\"\r\n\r\n".data(using: .utf8)!)
        
        body.append("\(nom)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"brandemail\"\r\n\r\n".data(using: .utf8)!)
        
        body.append("\(brandemail)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"adresse\"\r\n\r\n".data(using: .utf8)!)
        
        body.append("\(adresse)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"client\"\r\n\r\n".data(using: .utf8)!)
        
        body.append("\(client)\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"linkSocialmedia\"\r\n\r\n".data(using: .utf8)!)
        
        body.append("\(linkSocialmedia)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"numtelf\"\r\n\r\n".data(using: .utf8)!)
        
        body.append("\(numtelf)\r\n".data(using: .utf8)!)
        
       
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        
        body.append(imageData)
        
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        
        
        // Set the request body and content length
        
        request.httpBody = body
        
        request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        
        
        
        // Create a URLSessionDataTask to perform the request
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                
                completion(error)
                
                return
                
            }
            
            
            
            // Handle the response here
            
            guard let data = data else {
                
                let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned from server"])
                
                completion(error)
                
                return
                
            }
            
            
            
            
        }
        
        
        
        task.resume()
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
}








