//
//  QuoteService.swift
//  CombineInSwiftUI
//
//  Created by Dhawal Mahajan on 21/10/23.
//

import Foundation
import Combine

protocol QuoteServiceType {
    func getRandomQuote() -> AnyPublisher<Quote, Error>
}

class QuoteService: QuoteServiceType {
    func getRandomQuote() -> AnyPublisher<Quote, Error> {
        let url = URL(string: "https://api.quotable.io/random")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }.map {
                $0.data
            }.decode(type: Quote.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
