//
//  ViewController.swift
//  CombineInSwiftUI
//
//  Created by Dhawal Mahajan on 21/10/23.
//

import UIKit
import Combine
class QuoteViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    //MARK: Properties
    private let input: PassthroughSubject<QuoteViewModel.Input,Never> = .init()
    private let vm = QuoteViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidAppear)
    }
    
    private func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink {[weak self] event in
            switch event {
            case .fetchQuoteDidFail(error: let error):
                self?.quoteLabel.text = error.localizedDescription
            case .fetchQuoteDidSucceed(quote: let quote):
                self?.quoteLabel.text = quote.content
            case .toggleButton(isEnabled: let isEnabled):
                self?.refreshButton.isEnabled = isEnabled
            }
        }.store(in: &cancellables)
    }
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        input.send(.refreshButtonDidTap)
    }
}
