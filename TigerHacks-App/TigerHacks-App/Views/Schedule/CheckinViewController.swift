//
//  CheckinViewController.swift
//  TigerHacks-App
//
//  Created by Jacob Sokora on 10/17/19.
//  Copyright © 2019 Zukosky, Jonah. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth

class CheckinViewController: UIViewController {

	@IBOutlet weak var captureView: UIView!
	@IBOutlet weak var infoTableView: UITableView!
	@IBOutlet weak var eventNameLabel: UILabel!
	@IBOutlet weak var againButton: UIButton!

	var event: Event?
	var userInfo: CheckinResponse?

	var captureSession = AVCaptureSession()

	var videoPreviewLayer: AVCaptureVideoPreviewLayer?
	var qrCodeFrameView: UIView?

	private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]

    override func viewDidLoad() {
        super.viewDidLoad()

		guard let event = event else {
			dismiss(animated: false)
			return
		}

		infoTableView.dataSource = self
		eventNameLabel.text = "Checking in for \(event.title)"

        // Do any additional setup after loading the view.
		let deviceDiscoverySystem = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: .video, position: .back)

		guard let captureDevice = deviceDiscoverySystem.devices.first else {
			dismiss(animated: false)
			return
		}

		do {
			let input = try AVCaptureDeviceInput(device: captureDevice)
			captureSession.addInput(input)
			let captureMetadataOutput = AVCaptureMetadataOutput()
			captureSession.addOutput(captureMetadataOutput)
			captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
			captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
		} catch {
			print(error)
			dismiss(animated: false)
			return
		}

		self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
		self.videoPreviewLayer?.videoGravity = .resizeAspectFill
		self.videoPreviewLayer?.frame = self.captureView.layer.bounds
		self.captureView.layer.addSublayer(self.videoPreviewLayer!)

		self.captureSession.startRunning()

		self.qrCodeFrameView = UIView()

		if let qrCodeFrameView = self.qrCodeFrameView {
			qrCodeFrameView.layer.borderColor = UIColor.orange.cgColor
			qrCodeFrameView.layer.borderWidth = 2
			self.captureView.addSubview(qrCodeFrameView)
			self.view.bringSubviewToFront(qrCodeFrameView)
		}
    }

	@IBAction func checkAgain() {
		DispatchQueue.main.async {
			self.qrCodeFrameView?.frame = .zero
			self.captureSession.startRunning()
			self.userInfo = nil
			self.infoTableView.reloadData()
		}
	}
}

extension CheckinViewController: AVCaptureMetadataOutputObjectsDelegate {
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		if metadataObjects.count == 0 {
			qrCodeFrameView?.frame = .zero
			return
		}

		let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

		if supportedCodeTypes.contains(metadataObj.type) {
			let qrCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
			DispatchQueue.main.async {
				self.qrCodeFrameView?.frame = qrCodeObject!.bounds
			}
			if let url = metadataObj.stringValue {
				DispatchQueue.main.async {
					self.captureSession.stopRunning()
				}
				let pattern = "^https:\\/\\/(?:tigerhacks\\.firebaseapp\\.com|tigerhacks\\.com)\\/profile\\/(.*)$"
				let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
				if let match = regex?.firstMatch(in: url, options: [], range: NSRange(location: 0, length: url.utf16.count)), let idRange = Range(match.range(at: 1), in: url) {
					let userId = url[idRange]
					if let checkinURL = URL(string: "https://tigerhacks.com/api/checkin?event=\(event!.id)&userid=\(userId)") {
						Auth.auth().currentUser?.getIDToken { token, _ in
							if let token = token {
								let config = URLSessionConfiguration.default
								config.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
								URLSession(configuration: config).dataTask(with: checkinURL) { data, _, _ in
									if let data = data {
										let decoder = JSONDecoder()
										decoder.keyDecodingStrategy = .convertFromSnakeCase
										self.userInfo = try? decoder.decode(CheckinResponse.self, from: data)
										DispatchQueue.main.async {
											self.infoTableView.reloadData()
											self.againButton.isEnabled = self.userInfo != nil
										}
									}
								}.resume()
							}
						}
					}
				}
			}
		}
	}
}

extension CheckinViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return userInfo == nil ?  1 : 3
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "checkinCell", for: indexPath)
		if let userInfo = userInfo {
			switch indexPath.row {
			case 0: cell.textLabel?.text = userInfo.alreadyin ? "\(userInfo.name) alread checked in!" : "\(userInfo.name) checked in successfully!"
			case 1: cell.textLabel?.text = "Shirt size: \(userInfo.shirtSize)"
			case 3: cell.textLabel?.text = "Dietary restrictions: \(userInfo.dietaryRestrictions.joined(separator: ", "))"
			default: cell.textLabel?.text = ""
			}
		} else {
			cell.textLabel?.text = "Unable to check in user, please make sure they are registered"
		}
		return cell
	}
}

struct CheckinResponse: Codable {
	let checkins: [String]
	let name: String
	let shirtSize: String
	let dietaryRestrictions: [String]
	let alreadyin: Bool
}
