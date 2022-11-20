//
//  SearchREsultViewModel.swift
//  CovidCombineMVVM
//
//  Created by Marco Alonso Rodriguez on 20/11/22.
//

import Foundation

class SearchResultViewModel {
    
    private var searchResult: SearchResult
    
    init(searchResult: SearchResult) {
        self.searchResult = searchResult
    }
    
    var trackName: String {
        searchResult.trackName ?? "---"
    }
    
    var collectionName: String {
        searchResult.collectionName ?? "---"
    }
}
