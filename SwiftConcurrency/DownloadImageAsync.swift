//
//  DownloadImageAsync.swift
//  SwiftConcurrency
//
//  Created by Sivaram Yadav on 4/28/22.
//

import SwiftUI
import Combine

// keywords used:
/*
     1. async
     2. await
     3. throws
     4. throw
     5. do
     6. try
     7. catch
 */

// concepts used:
/*
    1. escaping closures
    2. combine
    3. swift concurrency
        3.1. async
        3.2. await
        3.3. task
        3.4. actor
 */


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
    
    // Download with Swift Concurrency
    func downloadWithAsync() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
//            let image = handleResponse(data: data, response: response)
//            return image
            return handleResponse(data: data, response: response) // if success return image
        } catch {
            debugPrint("Error in getting image data:", error.localizedDescription)
            throw error // if failure returns error
        }
    }
}

class DownloadImageAsyncViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let loader = DownloadImageAsyncImageLoader()
    
    var cancellables = Set<AnyCancellable>()

    func fetchImage() async {
        
        // self.image = UIImage(systemName: "heart.fill")
        /*
         //loader.downloadWithEscaping { [weak self] image, error in
         //    DispatchQueue.main.async {
         //        self?.image = image
         //    }
         //}
        */
        /*
         //loader.downloadWithCombine()
         //    .receive(on: DispatchQueue.main)
         //    .sink { _ in
         //
         //    } receiveValue: { [weak self] image in
         //        //  bcz we used .receive in combine way
         //        //  so we can put this syntax in comment
         //        //  DispatchQueue.main.async {
         //        //  }
         //        self?.image = image
         //    }
         //    .store(in: &cancellables)
        */
        
        let image = try? await loader.downloadWithAsync()
        // almost act as pulling to main thread
        // meaning code is now execute on main thread
        await MainActor.run {
            self.image = image
        }
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
            Task {
                await viewModel.fetchImage()
            }
        }
    }
}

struct DownloadImageAsync_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageAsync()
    }
}
