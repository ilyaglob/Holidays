//  Created by Илья Разумов on 21.12.2022.

import UIKit

enum Holidays {
    enum Persistence {
        struct Request {}

        struct Response {
			let holidayNames: [(date: String, name: String)]
			let sentYear: String
        }

        struct ViewModel {
			struct Displayed {
				let year: String
				let holidays: [(date: String, name: String)]
			}
			
			let model: Displayed
        }
    }
}
