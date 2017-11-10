//
//  StreamViewController.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 10/11/2017.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import UIKit

class StreamViewController: UIViewController {
	
	@IBOutlet weak var textView: UITextView!
	
	var streaming = false
	var vehicle: Vehicle?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		stopStream(self)
	}

	@IBAction func stream(_ sender: Any) {
		if !streaming {
			if let vehicle = vehicle {
				self.textView.text = ""
				api.openStream(vehicle: vehicle, dataReceived: {
					(event: StreamEvent?, error: Error?) in
					if let error = error {
						self.textView.text = error.localizedDescription
					} else {
						self.textView.text = "\(self.textView.text ?? "")\nevent:\n \(event?.description ?? "")"
					}
				})
			}
		}
		
		streaming = true
	}
	
	@IBAction func stopStream(_ sender: Any) {
		
		api.closeStream()
		
		streaming = false
	}

}
