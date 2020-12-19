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
    var stream: TeslaStreaming!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        stream = TeslaStreaming(teslaSwift: api)

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
                
                #if swift(>=5.1)
                if #available(iOS 13.0, *) {
                    _ = stream.streamPublisher(vehicle: vehicle).sink(receiveCompletion: { (completion) in
                        
                    }) { (event) in
                        self.processEvent(event: event)
                    }
                }
                
                #else
                    
                stream.openStream(vehicle: vehicle, dataReceived: {
                        (event: TeslaStreamingEvent) in
                        self.processEvent(event: event)
                    })
                    
                #endif
			}
		}
		
		streaming = true
	}
	
    func processEvent(event: TeslaStreamingEvent) {
        switch event {
        case .error(let error):
            textView.text = error.localizedDescription
        case .event(let event):
            textView.text = "\(self.textView.text ?? "")\nevent:\n \(event.descriptionKm)"
        case .disconnected:
            break
        case .open:
            break
        }
    }
    
    
	@IBAction func stopStream(_ sender: Any) {
		
        stream.closeStream()
		
		streaming = false
	}

}
