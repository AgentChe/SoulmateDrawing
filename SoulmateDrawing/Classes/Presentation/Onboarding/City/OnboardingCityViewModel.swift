//
//  OnboardingCityViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 11.03.2026.
//

import Foundation
import Combine

@Observable
final class OnboardingCityViewModel {
    var cityText: String {
        willSet {
            publisher.send(cityText)
        }
    }
    
    @MainActor
    private(set) var cityList: [CityModel] = []
    
    private(set) var isLoading = false
    
    @ObservationIgnored
    private let supportManager = SupportManager()
    @ObservationIgnored
    private var pagination: Pagination?
    @ObservationIgnored
    private var publisher = PassthroughSubject<String, Never>()
    
    private(set) var city: CityModel?
   
    init(city: String) {
        self.cityText = city
        searchCity()
    }
    
    func searchCity() {
        Task {
            let stream = publisher
                .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
                .values
            
            for await text in stream {
                if text != city?.address {
                    city = nil
                }
                pagination = nil
                guard text.count >= 3 else {
                    cityList = []
                    continue
                }
                
                do {
                    let result = try await supportManager.getLocations(for: text, page: nil)
                    pagination = result.pagination
                    cityList = result.items.map(CityModel.init)
                } catch {}
            }
        }
    }
    
    func loadNext() {
        Task {
            guard let pagination, pagination.next > pagination.current else { return }
            await MainActor.run {
                isLoading = true
            }
            do {
                let result = try await supportManager.getLocations(for: cityText, page: pagination.next)
                guard !Task.isCancelled else { return }
                
                let items = result.items.map(CityModel.init)
                self.pagination = result.pagination
                await MainActor.run {
                    isLoading = false
                    cityList.append(contentsOf: items)
                }
            } catch {
                isLoading = false
            }
            
        }
    }
    
    func didSelectCity(_ model: CityModel) {
        cityText = model.address
        city = model
    }
}

private extension CityModel {
    init(_ response: SupportLocationResponse.Item) {
        self.init(id: response.id, address: response.name)
    }
}
