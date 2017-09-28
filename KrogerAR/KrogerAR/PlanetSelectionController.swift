//
//  PlanetSelectionController.swift
//  KrogerAR
//
//  Created by Saint-Juste, Henry on 9/26/17.
//

import UIKit

protocol PlanetSelectionControllerDelegate: class {
    func PlanetSelectionControllerDidSelect(solarObject: SolarObject)
}

class PlanetSelectionController: UITableViewController {
    //------------------------
    // MARK: - Properties
    //------------------------
    weak var delegate: PlanetSelectionControllerDelegate? = nil
    private let cellIdentifier = "SolarSystemCell"
    /// The preferred size for the view controller’s view.
    private var size: CGSize!
    private var solarObjects: [SolarObject] = [SpaceObject(name: "Sun", description: "The sun lies at the heart of the solar system, where it is by far the largest object.", imageName: "sun")]
    //------------------------
    // MARK: - Initlization
    //------------------------
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) has not been implemented")
    }
    
    /**
     Planet Select Controller custom init.
     - Note: Pass in size of type CGSize.
     */
    init(size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = CGRect(origin: .zero, size: size)
        preferredContentSize = size
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solarObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = solarObjects[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = solarObjects[indexPath.row]
        delegate?.PlanetSelectionControllerDidSelect(solarObject: selectedItem)
    }
}
