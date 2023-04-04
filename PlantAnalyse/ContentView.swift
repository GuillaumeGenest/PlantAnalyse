//
//  ContentView.swift
//  PlantAnalyse
//
//  Created by Guillaume Genest on 28/03/2023.
//

import SwiftUI
import Vision
import VisionKit

struct ContentView: View {
    @StateObject var classifier = ImageClassifier()
    @State var value : Data?
    
    var body: some View {
        VStack {
            ImageUpload(valueImage: $value)
            Spacer()
            Group {
            if let imageClass = classifier.imageClass {
                HStack{
                    Text("Image categories:")
                        .font(.caption)
                    Text(imageClass)
                        .bold()
                        }
                } else {
                    HStack{
                    Text("Image categories: NA")
                        .font(.caption)
                        }
                        }
                    }
                    .font(.subheadline)
                    .padding()
            Button(action: {
                
                let uiImage = UIImage(data: value!)
                guard let ciImage = CIImage(image: uiImage!) else {
                               fatalError("Impossible de convertir l'image en CIImage.")
                }
                classifier.detect(uiImage: uiImage!)
                
                
                
                
            }, label: {
                ZStack {
                Text("Analyser")
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(35.0)
                }.shadow(radius: 10)
                })
        }
        .padding()
    }
}

/*
 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         ContentView()
     }
 }
 */



class ImageClassifier: ObservableObject {
    
    @Published private var classifier = Classifier()
    
    var imageClass: String? {
        classifier.results
    }
        
    func detect(uiImage: UIImage) {
        guard let ciImage = CIImage (image: uiImage) else { return }
        classifier.detect(ciImage: ciImage)
        
    }
        
}

/*
 let uiImage = UIImage(data: value!)
 guard let ciImage = CIImage(image: uiImage!) else {
                fatalError("Impossible de convertir l'image en CIImage.")
            }
 let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            
            // Créer une demande pour détecter si l'image contient une plante
            let plantDetectionRequest = VNClassifyImageRequest(model: try! VNCoreMLModel(for: PlantClassifier().model))
            
            // Effectuer la demande
            try? requestHandler.perform([plantDetectionRequest])
            
            // Récupérer les résultats de la demande
            let observations = plantDetectionRequest.results as? [VNClassificationObservation]
            
            // Vérifier si l'image contient une plante
            if let topObservation = observations?.first, topObservation.identifier == "Plant" {
                print("L'image contient une plante.")
                // Ici vous pouvez appeler une autre demande pour détecter l'espèce de la plante
            } else {
                print("L'image ne contient pas de plante.")
            }
 */
