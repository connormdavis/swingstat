//
//  CameraService.swift
//  SwingStat (iOS)
//
//  Created by Connor Davis on 4/26/22.
//

import AVFoundation
import UIKit

public class CameraService: NSObject {
    
    typealias PhotoCaptureSessionID = String
    
    @Published public var flashMode: AVCaptureDevice.FlashMode = .off
    @Published public var shouldShowAlertView = false
    @Published public var shouldShowSpinner = false
    @Published public var willCapturePhoto = false
    @Published public var isCameraButtonDisabled = true
    @Published public var isCameraUnavailable = true
    @Published public var isRecording = false
    @Published public var videoUrl: URL?

    
    // MARK: Alert properties
    public var alertError: AlertError = AlertError()
    
    // MARK: Session Management Properties
    
    public let session = AVCaptureSession()
    
    private var isSessionRunning = false
    
    private var isConfigured = false
    
    private var setupResult: SessionSetupResult = .success
    
    private let sessionQueue = DispatchQueue(label: "cameraSessionQ")
    
//    14. The device we'll use to capture video from.
    @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!
    
    private var videoOutput: AVCaptureMovieFileOutput?

// MARK: Device Configuration Properties
//    15. Video capture device discovery session.
    private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)

    
    public func configure() {
        sessionQueue.async {
            self.configureSession()
        }
    }
    
    public func checkForPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // The user has previously granted access to the camera.
            break
        case .notDetermined:
            /*
             The user has not yet been presented with the option to grant
             video access. Suspend the session queue to delay session
             setup until the access request has completed.
             */
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })
            
        default:
            // The user has previously denied access.
            // Store this result, create an alert error and tell the UI to show it.
            setupResult = .notAuthorized
            
            DispatchQueue.main.async {
                self.alertError = AlertError(title: "Camera Access", message: "SwiftCamera doesn't have access to use your camera, please update your privacy settings.", primaryButtonTitle: "Settings", secondaryButtonTitle: nil, primaryAction: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                                  options: [:], completionHandler: nil)
                    
                }, secondaryAction: nil)
                self.shouldShowAlertView = true
                self.isCameraUnavailable = true
                self.isCameraButtonDisabled = true
            }
        }
    }
    
    //  MARK: Session Managment
    
    private func configureDevice(_ videoDevice: inout AVCaptureDevice) {
        try! videoDevice.lockForConfiguration()
        var bestFormat: AVCaptureDevice.Format?
        
        for format in videoDevice.formats {
//                    // Check for P3_D65 support.
//
//                    guard format.supportedColorSpaces.contains(where: {
//
//                        $0 == AVCaptureColorSpace.P3_D65
//
//                    }) else { continue }

            

            // Check for 240 fps

            guard format.videoSupportedFrameRateRanges.contains(where: { range in

                range.maxFrameRate == 240

            }) else { continue }

            

            // Check for the resolution you want.
//
//                    guard format.formatDescription.dimensions.width == 1920 else { continue }
//
//                    guard format.formatDescription.dimensions.height == 1080 else { continue }

            

            bestFormat = format

            break // We found a suitable format, no need to keep looking.

        }
        
        videoDevice.activeFormat = bestFormat!
        videoDevice.activeVideoMinFrameDuration = CMTime(value: 1, timescale: 240)
        
        
        videoDevice.unlockForConfiguration()
    }
        
    // Call this on the session queue.
    /// - Tag: ConfigureSession
    private func configureSession() {
        if setupResult != .success {
            return
        }
        
        session.beginConfiguration()
        
        self.videoOutput = AVCaptureMovieFileOutput()
        session.sessionPreset = .inputPriority
        
        // Add video input.
        do {
            var defaultVideoDevice: AVCaptureDevice?
            
            if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                // If a rear dual camera is not available, default to the rear wide angle camera.
                defaultVideoDevice = backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                // If the rear wide angle camera isn't available, default to the front wide angle camera.
                defaultVideoDevice = frontCameraDevice
            }
            
            guard var videoDevice = defaultVideoDevice else {
                print("Default video device is unavailable.")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                
                // Device added, now configure it
                configureDevice(&videoDevice)
                
            } else {
                print("Couldn't add video device input to the session.")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
        } catch {
            print("Couldn't create video device input: \(error)")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        if session.canAddOutput(self.videoOutput!) {
            session.addOutput(self.videoOutput!)
        } else {
            print("Couldn't add video capture output to the session.")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
//        // Add the photo output.
//        if session.canAddOutput(photoOutput) {
//            session.addOutput(photoOutput)
//
//            photoOutput.isHighResolutionCaptureEnabled = true
//            photoOutput.maxPhotoQualityPrioritization = .quality
//
//        } else {
//            print("Could not add photo output to the session")
//            setupResult = .configurationFailed
//            session.commitConfiguration()
//            return
//        }
        
        session.commitConfiguration()
        self.isConfigured = true
        
        self.start()
    }
    
    public func start() {
        // We use our capture session queue to ensure our UI runs smoothly on the main thread.
        sessionQueue.async {
            if !self.isSessionRunning && self.isConfigured {
                switch self.setupResult {
                case .success:
                    self.session.startRunning()
                    self.isSessionRunning = self.session.isRunning
                    
                    if self.session.isRunning {
                        DispatchQueue.main.async {
                            self.isCameraButtonDisabled = false
                            self.isCameraUnavailable = false
                        }
                    }
                    
                case .configurationFailed, .notAuthorized:
                    print("Application not authorized to use camera")

                    DispatchQueue.main.async {
                        self.alertError = AlertError(title: "Camera Error", message: "Camera configuration failed. Either your device camera is not available or its missing permissions", primaryButtonTitle: "Accept", secondaryButtonTitle: nil, primaryAction: nil, secondaryAction: nil)
                        self.shouldShowAlertView = true
                        self.isCameraButtonDisabled = true
                        self.isCameraUnavailable = true
                    }
                }
            }
        }
    }
    
    public func stop(completion: (() -> ())? = nil) {
        sessionQueue.async {
            if self.isSessionRunning {
                if self.setupResult == .success {
                    self.session.stopRunning()
                    self.isSessionRunning = self.session.isRunning
                    
                    if !self.session.isRunning {
                        DispatchQueue.main.async {
                            self.isCameraButtonDisabled = true
                            self.isCameraUnavailable = true
                            completion?()
                        }
                    }
                }
            }
        }
    }
    
    private func createTempFileURL() -> URL {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                       FileManager.SearchPathDomainMask.userDomainMask, true).last
        let pathURL = NSURL.fileURL(withPath: path!)
        let fileURL = pathURL.appendingPathComponent("movie-\(NSDate.timeIntervalSinceReferenceDate).mov")
        print(" video url:  \(fileURL)")
        return fileURL
    }
        
    func startCaptureVideo() {
        self.isRecording = true
        let outFileUrl = createTempFileURL()
        videoOutput?.startRecording(to: outFileUrl, recordingDelegate: self)
    }
    
    func stopCaptureVideo() {
        self.isRecording = false
        videoOutput?.stopRecording()
    }
}

extension CameraService: AVCaptureFileOutputRecordingDelegate {
    public func fileOutput(_ output: AVCaptureFileOutput,
                        didFinishRecordingTo outputFileURL: URL,
                        from connections: [AVCaptureConnection],
                        error: Error?) {
        self.videoUrl = outputFileURL
        print("File recorded & saved to temp file \(outputFileURL.path)")
    }
}


public struct Video: Identifiable, Equatable {
    public var id: String
    
    public var originalData: Data
    
    public init(id: String = UUID().uuidString, originalData: Data) {
        self.id = id
        self.originalData = originalData
    }
}

public struct AlertError {
    public var title: String = ""
    public var message: String = ""
    public var primaryButtonTitle = "Accept"
    public var secondaryButtonTitle: String?
    public var primaryAction: (() -> ())?
    public var secondaryAction: (() -> ())?
    
    public init(title: String = "", message: String = "", primaryButtonTitle: String = "Accept", secondaryButtonTitle: String? = nil, primaryAction: (() -> ())? = nil, secondaryAction: (() -> ())? = nil) {
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryAction = secondaryAction
    }
}
