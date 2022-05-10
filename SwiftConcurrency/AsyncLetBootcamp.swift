//
//  AsyncLetBootcamp.swift
//  SwiftConcurrency
//
//  Created by Sivaram Yadav on 5/10/22.
//

import SwiftUI

struct AsyncLetBootcamp: View {
    
    @State private var images: [UIImage] = []
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    let url = URL(string: "https://picsum.photos/400")!
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationBarTitle("Async Let Bootcamp")
            .onAppear {
                // it is synchronus operation so we can directly call like nbelow way
                //self.images.append(UIImage(systemName: "heart.fill")!)
                
                // if it is async operation
                // then directly we can't call
                // we call from inside Task only
                // like below way
                //Task {
                //    do {
                //        let image1 = try await fetchImage()
                //        images.append(image1)
                //
                //        let image2 = try await fetchImage()
                //        images.append(image2)
                //
                //        let image3 = try await fetchImage()
                //        images.append(image3)
                //
                //        let image4 = try await fetchImage()
                //        images.append(image4)
                //
                //    } catch {
                //        debugPrint("Error:", error.localizedDescription)
                //    }
                //}
                
                
                // better code than above bcz,
                // here we made two tasks as synchronusly meaning at a time without any wait
                // but it is also not good practice
                //Task {
                //    do {
                //        let image1 = try await fetchImage()
                //        images.append(image1)
                //        let image2 = try await fetchImage()
                //        images.append(image2)
                //    } catch {
                //        debugPrint("Error:", error.localizedDescription)
                //    }
                //}
                //
                //Task {
                //    do {
                //        let image1 = try await fetchImage()
                //        images.append(image1)
                //        let image2 = try await fetchImage()
                //        images.append(image2)
                //    } catch {
                //        debugPrint("Error:", error.localizedDescription)
                //    }
                //}

                // better code than above bcz,
                // in above code images are loading sequentially
                // but we need to call parallelly
                // so for that we follow like below
                // using ===> async let

                Task {
                    do {
                        
                        // basically we are executing all four functions at same time
                        async let asyncImage1 = fetchImage()
                        async let asyncImage2 = fetchImage()
                        async let asyncImage3 = fetchImage()
                        async let asyncImage4 = fetchImage()
                        
                        // but we are waiting for results using await keyword as below
                        let (image1, image2, image3, image4) = await (try asyncImage1, try asyncImage2, try asyncImage3, try asyncImage4)
                        images.append(contentsOf: [image1, image2, image3, image4])
                    } catch {
                        debugPrint("Error:", error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func fetchImage() async throws -> UIImage {

        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

struct AsyncLetBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLetBootcamp()
    }
}
