//
//  ViewModel.swift
//  CovidCombineMVVM
//
//  Created by Marco Alonso Rodriguez on 20/11/22.
//

import Foundation
import UIKit

class ViewModel {
    
    let results: Binder<[SearchResult]> = Binder([])
    let error: Binder<String?> = Binder(nil)
    let isButtonEnabled: Binder<Bool> = Binder(false)
    let isLoadingEnabled: Binder<Bool> = Binder(false)

    
    var searchText: String? = nil {
        didSet { isButtonEnabled.value = getEnabledFlowStatus() }
    }
    
    //MARK: GetUIImage from server
    func getImageWithCompletion(urlString: String, completionHandler: @escaping(_ image: UIImage?, _ error: Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let image = UIImage(data: data),
                  let _ = response else { return }
            completionHandler(image, nil)
        }
        .resume()
    }
    
    func performSearch() {
        guard let gSearchText = searchText else { return }
        
        let search = gSearchText.addingPercentEncoding(
            withAllowedCharacters: .urlHostAllowed
        ) ?? ""
        
        guard let gUrl = URL(
            string: "https://itunes.apple.com/search?term=\(search)"
        ) else { return }
        
        isLoadingEnabled.value = true
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: gUrl)
                let response = try JSONDecoder()
                    .decode(SearchResponse.self, from: data)
                isLoadingEnabled.value = false
                results.value = response.results ?? []
            } catch {
                isLoadingEnabled.value = false
                self.error.value = "*** ERROR \(error) *** \(error.localizedDescription)"
                print("*** ERROR \(error) *** \(error.localizedDescription)")
            }
        }
    }
    
    func getSearchResultVM(at index: Int) -> SearchResultViewModel {
        let itm = results.value[index]
        return SearchResultViewModel(searchResult: itm)
    }
}

private extension ViewModel {
    func getEnabledFlowStatus() -> Bool {
        guard let gSearchText = searchText else { return false }
        return gSearchText.count >= 3
    }
}
