//
//  PhotoPicker.swift
//  PlantAnalyse
//
//  Created by Guillaume Genest on 28/03/2023.
//

import SwiftUI
import SwiftUI
import PhotosUI

struct ImageUpload: View {
    @Binding var valueImage : Data?
    @State var isPhotoPicker: Bool = false
    var body: some View {
        VStack{
            if valueImage == nil {
                VStack{
                    Image(systemName: "photo")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 40.0, height: 40.0)
                }.frame(maxWidth: .infinity)
                .frame(maxHeight: 250)
                .background(Color.gray)
                .padding(.horizontal,8)
                .cornerRadius(15)
                .overlay(PhotoPicker(value: $valueImage), alignment: .bottomTrailing)
                }
                else {
                    if let value = valueImage,
                       let uiImage = UIImage(data: value) {
                        VStack{
                            Image(uiImage: uiImage)
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity)
                                .frame(maxHeight: 250)
                                .cornerRadius(15)
                                .overlay(ButtonChangeImage(action: { valueImage  = nil}), alignment: .bottomTrailing)
                        }
                    }
                }
        }.frame(height: 250)
    }
}

struct ButtonChangeImage: View {
    var action: () -> Void
    var body: some View {
        Button(action: action,label: {
            Image(systemName: "camera.viewfinder")
                .resizable()
                .foregroundColor(.black)
                .frame(width: 30.0, height: 30.0)
                .padding()
        })
    }
}


struct PhotoPicker : View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @Binding var value : Data?
    var body : some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()) {
                VStack{
                    Image(systemName: "camera.viewfinder")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 40.0, height: 40.0)
                        .padding()
                }
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    // Retrieve selected asset in the form of Data
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                        value = data
                    }
                }
        }
    }
}

