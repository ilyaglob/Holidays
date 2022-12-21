//  Created by Илья Разумов on 21.12.2022.

import Foundation

struct HolidaysRequest: Codable {
	let year: String
	let countryCode: String
}

struct HolidaysResponse: Codable {
	let date: String
	let localName: String?
	let name: String
	let fixed: Bool
	let global: Bool
	let countries: [String]?
	let launchYear: Int?
	let types: [String]
}

extension HolidaysRequest: Endpoint {
	func endpoint() -> String {
		"publicholidays/\(year)/\(countryCode)"
	}
	
	func dispatch(onSuccess successHandler: @escaping ((_: [HolidaysResponse]) -> Void),
				  onFailure failureHandler: @escaping ((_: ApiClient.ErrorResponse?, _: Error) -> Void)) {
		ApiClient.dispatch(request: self,
						   httpMethod: .get,
						   onSuccess: successHandler,
						   onError: failureHandler)
	}
}
