//
//  RestAPITransport.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 04.01.2026.
//

import Foundation
import Alamofire

final class RestAPITransport {
    func callServerApi<T: Decodable>(requestBody: APIRequestBody) async throws -> T {
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        
        let encodedURL = requestBody.url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        var headers = requestBody.headers ?? HTTPHeaders()
        
        headers.add(HTTPHeader(name: "Access-Token", value: GlobalDefinitions.apiKey))
        
        let dataTask = manager.request(
            encodedURL,
            method: requestBody.method,
            parameters: requestBody.parameters,
            encoding: requestBody.encoding,
            headers: requestBody.headers
        )
        .validate(statusCode: [200, 201])
        .serializingResponse(using: APIDecodableResponseSerializer<T>())
        
        let result = await dataTask.result
        
        switch result {
        case let .success(success):
            return success
        case let .failure(failure):
            throw failure
        }
    }
    
    func callServerApi(requestBody: APIRequestBody) async throws {
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        
        let encodedURL = requestBody.url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        var headers = requestBody.headers ?? HTTPHeaders()
        
        headers.add(HTTPHeader(name: "Access-Token", value: GlobalDefinitions.apiKey))
        
        let dataTask = manager.request(
            encodedURL,
            method: requestBody.method,
            parameters: requestBody.parameters,
            encoding: requestBody.encoding,
            headers: requestBody.headers
        )
        .validate(statusCode: [200, 201])
        .serializingDecodable(ResponseContainer<String?>.self)
        
        let result = await dataTask.result
        
        switch result {
        case .success:
            return
        case let .failure(failure):
            throw failure
        }
    }
    
    func callMultipartServerApi<T: Decodable>(requestBody: APIRequestBody) async throws -> T {
        guard let url = URL(string: requestBody.url) else { throw NSError(domain: "RestAPITransport", code: -11) }
        let dataTask = AF.upload(
            multipartFormData: { multipartFormData in
                requestBody.parameters?.forEach { key, value in
                    guard let stringValue = value as? String, let data = stringValue.data(using: .utf8) else { return }
                    multipartFormData.append(data, withName: key)
                }
            },
            to: url,
            headers: requestBody.headers
        )
            .validate(statusCode: [200, 201])
            .serializingResponse(using: APIDecodableResponseSerializer<T>())
        
        let result = await dataTask.result
        
        switch result {
        case let .success(success):
            return success
        case let .failure(failure):
            throw failure
        }
    }
}

nonisolated struct ResponseContainer<T: Decodable & Sendable>: Decodable {
    let body: T?
    let error: APIError?
}

struct APIError: Error, Decodable {
    let code: Int
    let message: Int
}

final class APIDecodableResponseSerializer<T: Decodable>: ResponseSerializer where T: Sendable {
    let dataPreprocessor: DataPreprocessor
    let decoder: DataDecoder
    let emptyResponseCodes: Set<Int>
    let emptyRequestMethods: Set<HTTPMethod>
    
    init(dataPreprocessor: DataPreprocessor = PassthroughPreprocessor(),
                emptyResponseCodes: Set<Int> = [204, 205],
                emptyRequestMethods: Set<HTTPMethod> = [.head]) {
        self.dataPreprocessor = dataPreprocessor
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self.decoder = decoder
        self.emptyResponseCodes = emptyResponseCodes
        self.emptyRequestMethods = emptyRequestMethods
    }
    
    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> T {
        guard error == nil else { throw error! }
        
        guard var data, !data.isEmpty else {
            guard emptyResponseAllowed(forRequest: request, response: response) else {
                throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
            }

            guard let emptyResponseType = T.self as? EmptyResponse.Type, let emptyValue = emptyResponseType.emptyValue() as? T else {
                throw AFError.responseSerializationFailed(reason: .invalidEmptyResponse(type: "\(T.self)"))
            }

            return emptyValue
        }
        
        data = try dataPreprocessor.preprocess(data)
        
        do {
            let container = try decoder.decode(ResponseContainer<T>.self, from: data)
            if let error = container.error {
                throw error
            } else if let body = container.body {
                return body
            } else {
                throw AFError.responseSerializationFailed(reason: .decodingFailed(error: NSError(domain: "SoulmateDrawing", code: -1)))
            }
        } catch {
            throw AFError.responseSerializationFailed(reason: .decodingFailed(error: error))
        }
    }
}

extension DataRequest {
    @discardableResult
    func responseContainer<T: Decodable>(of type: T.Type = T.self, completionHandler: @escaping (AFDataResponse<T>) -> Void) -> Self {
        response(
            responseSerializer: APIDecodableResponseSerializer(),
            completionHandler: completionHandler
        )
    }
}
