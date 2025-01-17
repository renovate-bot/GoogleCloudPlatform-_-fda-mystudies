// License Agreement for FDA MyStudies
// Copyright © 2017-2019 Harvard Pilgrim Health Care Institute (HPHCI) and its Contributors.
// Copyright 2020 Google LLC
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the &quot;Software&quot;), to deal in the Software without restriction, including without
// limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
// Software, and to permit persons to whom the Software is furnished to do so, subject to the following
// conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial
// portions of the Software.
// Funding Source: Food and Drug Administration (“Funding Agency”) effective 18 September 2014 as
// Contract no. HHSF22320140030I/HHSF22301006T (the “Prime Contract”).
// THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
// OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

import CryptoSwift
import UIKit

let kDefaultPasscodeString = "Password123"
let kIsIphoneSimulator = "iPhone Simulator"
let kStoryboardIdentifierGateway = "Gateway"
let kStoryboardIdentifierSlideMenuVC = "FDASlideMenuViewController"

class SplashViewController: UIViewController {

  var isAppOpenedForFirstTime: Bool? = false
  fileprivate var standaloneStudy: StandaloneStudy?

  // MARK: - Viewcontroller Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let ud = UserDefaults.standard
    ud.set(true, forKey: kFromSplashScreen)
    ud.set(Upgrade.fromSplash.rawValue, forKey: kFromBackground)
    ud.set(false, forKey: kIsShowUpdateAppVersion)
    ud.set("", forKey: "pausedNotification")
    ud.removeObject(forKey: "isAlertShown")
    ud.setValue("", forKey: "consentEnrolledStatus")
    
    print("777userInfoDetails---\(UserDefaults.standard.value(forKey: "newactivity1"))")
    print("888userInfoDetails---\(UserDefaults.standard.value(forKey: "newactivity2"))")
    print("555userInfoDetails---\(UserDefaults.standard.value(forKey: "newactivity3"))")
    print("333userInfoDetails---\(UserDefaults.standard.value(forKey: "newactivity4"))")
    print("999userInfoDetails---\(UserDefaults.standard.value(forKey: "userInfoDetails"))")
    ud.set("", forKey: "userInfoDetails")
      UserDefaults.standard.set("", forKey: "performTaskBasedOnStudyStatus")
    UserDefaults.standard.set("", forKey: "performActivityTaskBasedOnStudyStatus")
//    UserDefaults.standard.set("", forKey: "newactivity2")
//    UserDefaults.standard.set("", forKey: "newactivity1")
//    UserDefaults.standard.set("", forKey: "newactivity3")
//    UserDefaults.standard.set("", forKey: "newactivity4")
    UserDefaults.standard.set("", forKey: "sync")
    UserDefaults.standard.synchronize()
    ud.synchronize()
  }

  override func viewWillAppear(_ animated: Bool) {

    if DBHandler().initilizeCurrentUser() {

      if let authToken = FDAKeychain.shared[kUserAuthTokenKeychainKey] {
        User.currentUser.authToken = authToken
      }
      if let refreshToken = FDAKeychain.shared[kUserRefreshTokenKeychainKey] {
        User.currentUser.refreshToken = refreshToken
      }
    }

    self.checkIfAppLaunchedForFirstTime()

    // Checks AuthKey, If exists navigate to HomeController else GatewayDashboard
    if Utilities.isStandaloneApp() {
      self.initilizeStudyForStandaloneApp()
    } else {

      if User.currentUser.authToken != nil {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.checkPasscode(viewController: self)
        self.navigateToGatewayDashboard()

      } else {
        // Gateway App
        self.navigateToHomeController()
      }
    }

  }

  /// Navigating to Home Screen and load HomeViewController from Login Storyboard
  func navigateToHomeController() {

    let loginStoryboard = UIStoryboard.init(
      name: kLoginStoryboardIdentifier,
      bundle: Bundle.main
    )
    let homeViewController = loginStoryboard.instantiateViewController(
      withIdentifier: "HomeViewController"
    )
    self.navigationController?.pushViewController(homeViewController, animated: true)
  }

  func initilizeStudyForStandaloneApp() {

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(SplashViewController.studySetupComplete),
      name: NSNotification.Name(rawValue: "StudySetupCompleted"),
      object: nil
    )

    standaloneStudy = StandaloneStudy()
    standaloneStudy?.setupStandaloneStudy()

  }

  /// Navigate to `StudyHomeViewController`
  func navigateToStudyHomeController() {
    let studyStoryBoard = UIStoryboard.init(name: kStudyStoryboard, bundle: Bundle.main)
    let studyHomeController =
      studyStoryBoard.instantiateViewController(
        withIdentifier: String(describing: StudyHomeViewController.classForCoder())
      )
      as! StudyHomeViewController
    self.navigationController?.pushViewController(studyHomeController, animated: true)
  }

  /// Navigate to gateway Dashboard
  func navigateToGatewayDashboard() {
    NotificationCenter.default.removeObserver(
      self,
      name: NSNotification.Name(rawValue: "StudySetupCompleted"),
      object: nil
    )
    self.createMenuView()
  }

  @objc func studySetupComplete() {

    NotificationCenter.default.removeObserver(
      self,
      name: NSNotification.Name(rawValue: "StudySetupCompleted"),
      object: nil
    )
    if User.currentUser.authToken != nil && User.currentUser.authToken.count > 0 {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.checkPasscode(viewController: self)
      self.createMenuView()
    } else {
      self.createMenuView()
    }

  }

  /// Navigating to Study list and Load FDASlideMenuViewController from Gateway Storyboard
  func createMenuView() {
    let storyboard = UIStoryboard(name: kStoryboardIdentifierGateway, bundle: nil)
    let fda =
      storyboard.instantiateViewController(
        withIdentifier: kStoryboardIdentifierSlideMenuVC
      )
      as! FDASlideMenuViewController
    self.navigationController?.pushViewController(fda, animated: true)
  }

  /// Update Encryption Key & IV on first time launch
  func checkIfAppLaunchedForFirstTime() {

    if isAppOpenedForFirstTime == false {
      let appDelegate = UIApplication.shared.delegate as? AppDelegate
      appDelegate?.updateKeyAndInitializationVector()
    }

  }
}

// MARK: - ORKTaskViewController Delegate
extension SplashViewController: ORKTaskViewControllerDelegate {

  func taskViewControllerSupportsSaveAndRestore(_ taskViewController: ORKTaskViewController)
    -> Bool
  {
    return true
  }

  public func taskViewController(
    _ taskViewController: ORKTaskViewController,
    didFinishWith reason: ORKTaskViewControllerFinishReason,
    error: Error?
  ) {

    switch reason {

    case ORKTaskViewControllerFinishReason.completed: break

    case ORKTaskViewControllerFinishReason.failed: break

    case ORKTaskViewControllerFinishReason.discarded: break

    case ORKTaskViewControllerFinishReason.saved: break

    @unknown default:
      break
    }
    taskViewController.dismiss(animated: true, completion: nil)
  }

  func taskViewController(
    _ taskViewController: ORKTaskViewController,
    stepViewControllerWillAppear stepViewController: ORKStepViewController
  ) {

  }
}
