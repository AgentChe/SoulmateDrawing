//
//  SoulmateCheckProfileViewModel.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 29.01.2026.
//

import Foundation

@Observable
final class SoulmateCheckProfileViewModel {
    private(set) var screenState: ScreenState = .loaded
    private(set) var profileName: String = ""
    private(set) var mainPoints: [MainPoint] = []
    private(set) var profileInfo: [SoulmateProfileInfo] = []
    
    @ObservationIgnored
    private let discoverManager = DiscoverManager()
    @ObservationIgnored
    private let profileManager = ProfileManager()
    
    init() {
        load()
    }
    
    func load() {
        Task {
            do {
                await MainActor.run {
                    screenState = .loading
                }
                async let discoveryRequest = discoverManager.discover(forceUpdate: false)
                async let profileRequest = profileManager.getProfile(forceUpdate: false)
                
                let (discovery, profile) = try await (discoveryRequest, profileRequest)
                let bornDate = profile.bornDate?.formatted(date: .long, time: .omitted) ?? ""
                let location = profile.city
                let time = profile.bornDate?.formatted(date: .omitted, time: .shortened) ?? ""
                
                let info: [SoulmateProfileInfo] = [
                    .date(bornDate),
                    .place(location),
                    .time(time)
                ]
                
                await MainActor.run {
                    mainPoints = discovery.mainPoints
                    profileName = profile.name
                    profileInfo = info
                    screenState = .loaded
                }
            } catch {
                await MainActor.run {
                    screenState = .error
                }
            }
        }
    }
}
