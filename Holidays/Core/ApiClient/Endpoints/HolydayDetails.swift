//  Created by Илья Разумов on 21.12.2022

import Foundation

struct HolydayDetailsRequest: Codable {}

struct HolydayDetailsResponse: Codable {}

extension HolydayDetailsRequest: Endpoint {
	func endpoint() -> String {
		""
	}
	
	func dispatch(onSuccess successHandler: @escaping ((_: HolydayDetailsResponse) -> Void),
				  onFailure failureHandler: @escaping ((_: ApiClient.ErrorResponse?, _: Error) -> Void)) {
		ApiClient.dispatch(request: self,
						   onSuccess: successHandler,
						   onError: failureHandler)
	}
}
