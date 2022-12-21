//  Created by Илья Разумов on 21.12.2022.

import UIKit

protocol HolidaysDisplayLogic: AnyObject {
	func displayHolidays(viewModel: Holidays.Persistence.ViewModel)
	func displayError(_ message: String)
	func displayConcreteHoliday(_ holiday: Holiday)
}

class HolidaysViewController: UIViewController, HolidaysDisplayLogic {
	private enum Constants {
		static let cellReuseId: String = String(describing: UITableViewCell.self)
		static let sectionHeight: CGFloat = 75.0
		static let cellHeight: CGFloat = 60.0
		static let footerHeight: CGFloat = 80.0
	}
	
	@IBOutlet private var contentTableView: UITableView!
	
	private var interactor: HolidaysBusinessLogic?
	private var router: (NSObjectProtocol & HolidaysRoutingLogic & HolidaysDataPassing)?
	
	private var models: [Holidays.Persistence.ViewModel.Displayed] = []

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		update()
	}

	private func setup() {
		let viewController = self
		let interactor = HolidaysInteractor()
		let presenter = HolidaysPresenter()
		let router = HolidaysRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
	}
	
	private func setupUI() {
		navigationItem.title = "HL 🥳"
		contentTableView.delegate = self
		contentTableView.dataSource = self
		contentTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellReuseId)
	}
}

// MARK: - Displayable

extension HolidaysViewController {
	func displayHolidays(viewModel: Holidays.Persistence.ViewModel) {
		models.append(viewModel.model)
		contentTableView.reloadData()
	}
	
	func displayError(_ message: String) {
		router?.showError(message)
	}
	
	func displayConcreteHoliday(_ holiday: Holiday) {
		router?.routeToHolidayDetails(holiday: holiday)
	}
}

// MARK: - Interactor Calls

private extension HolidaysViewController {
	func update() {
		interactor?.getHolidays()
	}
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension HolidaysViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		models.count
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		Constants.sectionHeight
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		models[section].year
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		models[section].holidays.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		Constants.cellHeight
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = contentTableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath)
		cell.textLabel?.text = models[indexPath.section].holidays[indexPath.row]
		cell.backgroundColor = .cyan
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedModel = models[indexPath.section]
		interactor?.obtainConcreteHoliday(with: selectedModel.holidays[indexPath.row], year: selectedModel.year)
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

// MARK: - UIScrollViewDelegate

extension HolidaysViewController {
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		if isNeedLoadMore(scrollView) {
			interactor?.decrementeYearOffsetAndLoad()
		}
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if !decelerate, isNeedLoadMore(scrollView) {
			interactor?.decrementeYearOffsetAndLoad()
		}
	}
	
	private func isNeedLoadMore(_ scrollView: UIScrollView) -> Bool {
		let position = scrollView.contentOffset.y
		return position >= (scrollView.contentSize.height - scrollView.frame.height)
	}
}
