//
//  CheckedContinuationBootcamp.swift
//  SwiftConcurrency
//
//  Created by Sivaram Yadav on 5/16/22.
//

import SwiftUI


class CheckedContinuationBootcampNetworkManager: ObservableObject {
    
    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            return data
        } catch  {
            throw error
        }
    }
    
    func getData2(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }
    
    func getHeartImageFromDatabase(completionHandler: @escaping (_ image: UIImage) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            completionHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    func getHeartImageFromDatabase() async -> UIImage {
        return await withCheckedContinuation { continuation in
            getHeartImageFromDatabase { image in
                continuation.resume(returning: image)
            }
        }
    }
}

class CheckedContinuationBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let networkManager = CheckedContinuationBootcampNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/400") else { return }
        do {
            //let data = try await networkManager.getData(url: url)
            let data = try await networkManager.getData2(url: url)
            if let image = UIImage(data: data) {
                self.image = image
            }
        } catch  {
            debugPrint("Error:", error.localizedDescription)
        }
    }
    
    func getHeartImage() {
        networkManager.getHeartImageFromDatabase { [weak self] image in
            self?.image = image
        }
    }
    
    func getHeartImage2() async {
        let image = await networkManager.getHeartImageFromDatabase()
        self.image = image
    }
}

struct CheckedContinuationBootcamp: View {
    
    @StateObject private var viewModel = CheckedContinuationBootcampViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            //await viewModel.getImage()
            //viewModel.getHeartImage()
            await viewModel.getHeartImage2()
        }
    }
}

struct CheckedContinuationBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CheckedContinuationBootcamp()
    }
}
