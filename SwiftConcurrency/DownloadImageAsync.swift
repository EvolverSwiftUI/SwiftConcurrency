//
//  DownloadImageAsync.swift
//  SwiftConcurrency
//
//  Created by Sivaram Yadav on 4/28/22.
//

import SwiftUI
import Combine

class DownloadImageAsyncImageLoader {
    
    let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                return nil
            }
        
        return image
    }
    
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            // as below code is reusable so made a separate function and utilized below
            
            //guard
            //    let data = data,
            //    let image = UIImage(data: data),
            //    let response = response as? HTTPURLResponse,
            //    response.statusCode >= 200 && response.statusCode < 300 else {
            //        completionHandler(nil, error)
            //        return
            //    }
            //completionHandler(image, nil)
            
            let image = self?.handleResponse(data: data, response: response)
            completionHandler(image, error)
        }
        .resume()
    }
    
    // As same as Result type,
    // here also AnyPublisher also generic type
    // So we need to mention
    // the success type and failure types as well
    // in angular braces
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
}

class DownloadImageAsyncViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let loader = DownloadImageAsyncImageLoader()
    
    var cancellables = Set<AnyCancellable>()

    func fetchImage() {
//        self.image = UIImage(systemName: "heart.fill")
        
//        loader.downloadWithEscaping { [weak self] image, error in
//            DispatchQueue.main.async {
//                self?.image = image
//            }
//        }
        
        loader.downloadWithCombine()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] image in
                //  bcz we used .receive in combine way
                //  so we can put this syntax in comment
                //  DispatchQueue.main.async {
                //  }
                self?.image = image
            }
            .store(in: &cancellables)
    }
}

struct DownloadImageAsync: View {
    
    @StateObject private var viewModel = DownloadImageAsyncViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        .onAppear {
            viewModel.fetchImage()
        }
    }
}

struct DownloadImageAsync_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageAsync()
    }
}
