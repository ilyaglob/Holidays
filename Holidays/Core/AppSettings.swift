//  Created by Илья Разумов on 21.12.2022.

import Foundation

protocol AppSettingsProtocol {
	var baseUrlString: String { get }
}

class AppSettings {
	static let shared = AppSettings()
	
	var baseUrlString: String {
		"https://date.nager.at/api/v3/"
	}
	
	private init() {}
}
