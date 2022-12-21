//  Created by Илья Разумов on 21.12.2022.

import Foundation

struct Holiday: Equatable {
	let date: String
	let localName: String?
	let name: String
	let fixed: Bool
	let global: Bool
	let countries: [String]?
	let launchYear: Int?
	let types: [String]
}
