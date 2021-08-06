

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var profilePresenter = ProfilePresenter(profilePresenterDelegate: self)
    let supportClass = SupportClass()
    
    let minRowHeight: CGFloat = 45
   
    var profileTableViewData = [ProfileModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        profilePresenter.getProfileData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setUpPhotoLayer()
        setUpCornerRadiusButton()
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        Alert.showBeforeLogOut(on: self) { (text) in
            self.profilePresenter.alertLogOut(confirmation: text)
        }
    }
    
    func setUpPhotoLayer() {
        profilePhoto.layer.borderWidth = 1.0
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.cornerRadius = profilePhoto.frame.size.width / 2
        profilePhoto.clipsToBounds = true
    }
    
    func setUpCornerRadiusButton() {
        logoutButton.layer.cornerRadius = 20
    }
}
    
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileTableViewData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewHeight = tableView.frame.height
        let temp = tableViewHeight / CGFloat(profileTableViewData.count)
        return temp > minRowHeight ? temp : minRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        
        cell.imageIcon.image = UIImage(named: profileTableViewData[indexPath.row].icon)
        cell.label.text = profileTableViewData[indexPath.row].labelIcon
        cell.accessoryView = cell.accesoryImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        profilePresenter.performSegue(indexPathRow: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
    
extension ProfileViewController: ProfilePresenterDelegate {
    
    func showSupportVC() {
        profilePresenter.showSupportAlert(vc: self)
    }
    
    func performSegue(identifier: String) {
        performSegue(withIdentifier: identifier, sender: self)
    }
    
    func logoutAlert() {
        self.navigationController?.navigationController?.popToRootViewController(animated: true)
    }
    
    func setProfileData(profileData: [ProfileModel]) {
        profileTableViewData = profileData
    }
}
