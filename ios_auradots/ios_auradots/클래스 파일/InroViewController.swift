import UIKit

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 화면 아무 곳이나 터치되면 호출됨
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(identifier: "HomeViewController") as? HomeViewController {
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
}
