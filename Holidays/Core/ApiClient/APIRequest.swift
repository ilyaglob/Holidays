//  Created by Илья Разумов on 21.12.2022.

import Foundation

protocol Endpoint {
	func endpoint() -> String
}

class ApiClient {
	struct ErrorResponse: Codable {
		let status: String
		let code: Int
		let message: String
	}
	
	enum HttpMethod: String {
		case post = "POST"
		case get = "GET"
		case put = "PUT"
		case delete = "DELETE"
	}
	
	enum APIError: Error {
		case invalidEndpoint
		case errorResponseDetected
		case noData
	}
}

// MARK: - UrlRequestHelper

extension ApiClient {
	public static func urlRequest(from request: Endpoint) -> URLRequest? {
		let endpoint = request.endpoint()
		guard let endpointUrl = URL(string: "\(AppSettings.shared.baseUrlString)\(endpoint)") else {
			return nil
		}
		
		var endpointRequest = URLRequest(url: endpointUrl)
		endpointRequest.addValue("application/json", forHTTPHeaderField: "Accept")
		return endpointRequest
	}
}

// MARK: - ResponseProcessing

extension ApiClient {
	public static func processResponse<T: Codable, E: Codable>(_ dataOrNil: Data?,
															   _ urlResponseOrNil: URLResponse?,
															   _ errorOrNil: Error?,
															   onSuccess: ((_: T) -> Void),
															   onError: ((_: E?, _: Error) -> Void)) {
		
		if let data = dataOrNil {
			do {
				let decodedResponse = try JSONDecoder().decode(T.self, from: data)
				onSuccess(decodedResponse)
			} catch {
				let originalError = error
				
				do {
					let errorResponse = try JSONDecoder().decode(E.self, from: data)
					onError(errorResponse, APIError.errorResponseDetected)
				} catch {
					onError(nil, originalError)
				}
			}
		} else {
			onError(nil, errorOrNil ?? APIError.noData)
		}
	}
}

// MARK: - Dispatch

extension ApiClient {
	public static func dispatch<R: Codable & Endpoint, T: Codable, E: Codable>(request: R,
																			   httpMethod: HttpMethod = .post,
																			   onSuccess: @escaping ((_: T) -> Void),
																			   onError: @escaping ((_: E?, _: Error) -> Void)) {
		
		guard var endpointRequest = self.urlRequest(from: request) else {
			onError(nil, APIError.invalidEndpoint)
			return
		}
		endpointRequest.httpMethod = httpMethod.rawValue
		endpointRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		if httpMethod != .get {
			do {
				endpointRequest.httpBody = try JSONEncoder().encode(request)
			} catch {
				onError(nil, error)
				return
			}
		}
		
		URLSession.shared.dataTask(
			with: endpointRequest,
			completionHandler: { (data, urlResponse, error) in
				DispatchQueue.main.async {
					self.processResponse(data, urlResponse, error, onSuccess: onSuccess, onError: onError)
				}
			}).resume()
		
	}
}
