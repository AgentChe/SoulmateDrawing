//
//  BondsManager.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 09.01.2026.
//

import Foundation

final class BondsManager {
    private lazy var restApiTransport = RestAPITransport()
    private lazy var sessionManager = SessionManager()
    
    func createPerson(_ person: NewPersonModel) async throws -> PersonResponse {
        let request = BondsCreatePersonRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            model: person
        )
        // TODO: Раскомментить
//        return try await restApiTransport.callServerApi(requestBody: request)
        try await Task.sleep(for: .seconds(1.5))
        return PersonResponse(id: UUID().uuidString, name: person.name, singImage: nil)
    }
    
    func personList(forceUpdate: Bool) async throws -> [PersonResponse] {
        if forceUpdate {
            return try await personList()
        } else {
            do {
                return try cachedPersonList()
            } catch {
                return try await personList()
            }
        }
    }
}

private extension BondsManager {
    func personList() async throws -> [PersonResponse] {
        let request = BondsPersonListRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        // TODO: Раскомментить
//        let response: [PersonResponse] = try await restApiTransport.callServerApi(requestBody: request)
        try await Task.sleep(for: .seconds(1))
        let response: [PersonResponse] = [
            .init(id: "1", name: "Megan", singImage: nil),
            .init(id: "2", name: "Megan1", singImage: nil),
            .init(id: "3", name: "Megan2", singImage: nil),
            .init(id: "4", name: "Megan3", singImage: nil),
            .init(id: "5", name: "Fox", singImage: nil),
            .init(id: "6", name: "Fox1", singImage: nil),
            .init(id: "7", name: "Fox2", singImage: nil),
            .init(id: "8", name: "Fox3", singImage: nil)
        ]
        
        if let data = try? JSONEncoder().encode(response) {
            UserDefaults.standard.set(data, forKey: Constants.personListKey)
        }
        
        return response
    }
    
    func cachedPersonList() throws -> [PersonResponse] {
        let data = UserDefaults.standard.data(forKey: Constants.personListKey)
        guard let data else { throw NSError(domain: "BondsManager", code: -1) }
        return try JSONDecoder().decode([PersonResponse].self, from: data)
    }
}

private extension BondsManager {
    enum Constants {
        static let personListKey = "bonds_manager_person_list_key"
    }
}
