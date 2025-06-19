//
//  RecordingViewController.swift
//  EchoChat
//
//  Created by Sandip on 18/06/25.
//

import UIKit
import DSWaveformImage
import DSWaveformImageViews
import AVFoundation

class RecordingViewController: UIViewController {
    
    @IBOutlet weak var userBackgroundImage: UIImageView!
    @IBOutlet weak var ivOverlayProfile: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblTagName: UILabel!
    @IBOutlet weak var vwProfileContainer: UIView!
    @IBOutlet weak var vwNavigationBar: UIView!
    @IBOutlet weak var customProgressView: RingProgressView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var recordingWaveView: WaveformLiveView!
    @IBOutlet weak var lblTimer: UILabel!
    var presenter : RecordingViewToPresenterProtocol?
    
    // wave animation variable
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    private var playerPlaybackTimer: Timer?
    private var displayLink: CADisplayLink?
    private var isRecording = false
    private var isPlaying = false
    private var isPause = false
    private var recordingURL: URL?
    private var currentTime: TimeInterval = 0
    private var imageDrawer: WaveformImageDrawer!
    private var recordedSegments: [URL] = []
    
    @IBOutlet weak var recordingContainerView: UIView!
    @IBOutlet weak var btnPlayPause: UIButton!
    
    private enum RecordingState {
        case idle
        case recording
        case recorded
        case playing
    }
    
    private var currentState: RecordingState = .idle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        self.navigationItem.backButtonTitle = ""
        self.tabBarController?.navigationItem.backButtonTitle = ""
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
}

// MARK: -
// MARK: Private methods
extension RecordingViewController {
    
    private func layoutSetup() {
        setUpCustomFont()
        requestMicPermission()
        setCardData()
        setRecordingWaveView()
        setProgressView()
        playSoundIfSilent()
    }
    
    private func setUpCustomFont() {
        self.lblTagName.font = FontManager.shared.font(.bold, size: 11)
        //self.lblCaption.font = FontManager.shared.font(.italic, size: 12)
        self.lblQuestion.font = FontManager.shared.font(.bold, size: 24)
        self.lblTitle.font = FontManager.shared.font(.bold, size: 18)
    }
    
    private func setProgressView() {
        customProgressView.isCompleted = true
        customProgressView.progressColor = .gray
        customProgressView.lineWidth = 5.0
        customProgressView.progress = 0.0
    }
    
    private func setCardData() {
        let cardData = presenter?.getUserCardInfo()
        self.lblTitle.text = (cardData?.name ?? "") + ", " + "\(cardData?.age ?? 0)"
        self.lblQuestion.text = cardData?.question ?? ""
        profileImageView.image = UIImage(named: cardData?.profilePic ?? "")
    }
    
}
// MARK: -
// MARK: IBAction Methods
extension RecordingViewController {
    
    @IBAction private func actionPlayPause(_ sender: Any) {
        
        switch currentState {
        case .idle:
            recordingWaveView.reset()
            recordingWaveView.configuration = recordingWaveView.configuration.with(
                style: Waveform.Style.striped(.init(color: #colorLiteral(red: 0.2117647059, green: 0.2235294118, blue: 0.2431372549, alpha: 0.95), width: 3, spacing: 3))
            )
            startRecording()
            currentState = .recording
            btnPlayPause.setImage(UIImage(named: "ic_recordingStop"), for: .normal)

        case .recording:
            stopRecording()
            currentState = .recorded
            btnPlayPause.setImage(UIImage(named: "ic_play"), for: .normal)
            
        case .recorded:
            if isRecording {
                stopRecording()
            }
            recordingWaveView.reset()
            recordingWaveView.configuration = recordingWaveView.configuration.with(
                style: Waveform.Style.striped(.init(color: #colorLiteral(red: 0.7098039216, green: 0.6980392157, blue: 1, alpha: 1), width: 3, spacing: 3))
            )
            startPlayback()
            currentState = .playing
            btnPlayPause.setImage(UIImage(named: "ic_pause"), for: .normal)

        case .playing:
            pausePlayback()
            currentState = .recorded
            btnPlayPause.setImage(UIImage(named: "ic_play"), for: .normal)
        }
    }
    
    @IBAction private func actionDelete(_ sender: Any) {
        stopRecording()
        recordingURL = nil
        lblTimer.text = "00:00"
        player?.stop()
        recorder?.stop()
        isRecording = false
        isPlaying = false
        currentState = .idle
        
        self.customProgressView.setProgress(0.0, duration: 0.5)
        
        recordingWaveView.reset()
        recordingWaveView.configuration = recordingWaveView.configuration.with(
            style: Waveform.Style.striped(.init(color: #colorLiteral(red: 0.2117647059, green: 0.2235294118, blue: 0.2431372549, alpha: 0.95), width: 3, spacing: 3))
        )
        startRecording()
        stopRecording()
        
        btnPlayPause.setImage(UIImage(named: "ic_recordingStart"), for: .normal)
    }
    
    @IBAction private func actionSubmit(_ sender: Any) {
        // Update the static card data and back to chat screen
        presenter?.updateCardDetails(id: 0)
        if let updatedCard = presenter?.getUserCardInfo() {
            presenter?.delegate?.didUpdateCard(updatedCard)
        }
        presenter?.navigationBackToChat()
    }
    
    @IBAction private func backArrowActionEvent(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: -
// MARK: ZoomTransitionAnimating
extension RecordingViewController: ZoomTransitionAnimating {
    var transitionSourceImageView: UIImageView {
        let cardData = presenter?.getUserCardInfo()
        let imageView = UIImageView(image: UIImage(named: cardData?.profilePic ?? ""))
        imageView.contentMode = self.userBackgroundImage.contentMode
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.frame = self.userBackgroundImage.frame
        return imageView;
    }
    
    var transitionSourceBackgroundColor: UIColor? {
        return self.view.backgroundColor
    }
    
    var transitionDestinationImageViewFrame: CGRect {
        let width = self.view.frame.width
        let frame = CGRect(origin: self.userBackgroundImage.frame.origin, size: CGSize(width: width, height: self.userBackgroundImage.bounds.size.height + 25.0))
        return frame
    }
}

// MARK: -
// MARK: ZoomTransitionDelegate
extension RecordingViewController: ZoomTransitionDelegate {
    func zoomTransitionAnimator(animator: ZoomTransitionAnimator,
                                didCompleteTransition didComplete: Bool,
                                animatingSourceImageView imageView: UIImageView) {
        
        self.ivOverlayProfile.alpha = 1.0
        self.userBackgroundImage.image = imageView.image
        self.vwNavigationBar.slideDownWithAlpha()
        self.vwProfileContainer.slideUpWithAlpha()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.recordingContainerView.slideUpWithAlpha()
        })
    }
}

// MARK: -
// MARK: Presenter to view data updates
extension RecordingViewController: RecordingPresenterToViewProtocol {
    func showCardInfo() {
        setCardData()
    }
    
    func showError() {
        let alert = UIAlertController(title: "Alert", message: "Problem Fetching User Cards", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: -
// MARK: Sound Wave animation
extension RecordingViewController: AVAudioPlayerDelegate {
    
    private func requestMicPermission() {
        // Ask for allowing the microphone permission
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if !granted {
                print("Microphone permission denied")
            }
        }
    }
    
    private func playSoundIfSilent() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting audio session: \(error.localizedDescription)")
        }
    }
    
    private func sideForSelection(index: Int) -> Waveform.Damping.Sides {
        switch index {
        case 0: return .left
        case 1: return .right
        case 2: return .both
        default: fatalError()
        }
    }
    
    private func setRecordingWaveView() {
        // configure sound wave view with
        
        lblTimer.text = "00:00"
        lblTimer.textAlignment = .center
        lblTimer.font = FontManager.shared.font(.regular, size: 14)
        btnSubmit.titleLabel?.font = FontManager.shared.font(.regular, size: 17)
        btnDelete.titleLabel?.font = FontManager.shared.font(.regular, size: 17)
        
        recordingWaveView.shouldDrawSilencePadding = true
        recordingWaveView.configuration = recordingWaveView.configuration.with(
            style: Waveform.Style.striped(.init(color: #colorLiteral(red: 0.2117647059, green: 0.2235294118, blue: 0.2431372549, alpha: 0.95), width: 3, spacing: 3))
        )
        recordingWaveView.configuration = recordingWaveView.configuration.with(
            damping: recordingWaveView.configuration.damping?.with(percentage: 0.125)
        )
        recordingWaveView.configuration = recordingWaveView.configuration.with(
            damping: recordingWaveView.configuration.damping?.with(
                sides: sideForSelection(index: 2)
            )
        )
    }
    
    private func resumeRecording() {
        recorder?.record()
        isPlaying = true
        isPause = false
        startTimer()
        startWaveform()
    }
    
    private func pauseRecording() {
        recorder?.pause()
        isPlaying = true
        stopTimer()
        stopWaveform()
    }
    
    @objc private func deleteRecording() {
        recordingURL = nil
        lblTimer.text = "00:00"
        player?.stop()
        recorder?.stop()
        isRecording = false
        isPlaying = false
    }
    
    @objc private func submitRecording() {
        print("Submit tapped with file: \(String(describing: recordingURL))")
        if isRecording {
            stopRecording()
        }
        recordingWaveView.reset()
        startPlayback()
    }
    
    private func startRecording() {
        
        currentTime = 0
        lblTimer.text = formatTime(currentTime)
        
        // let filename = UUID().uuidString + ".m4a"
        // let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("recording.m4a")
        recordingURL = url
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)
            
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.isMeteringEnabled = true
            recorder?.record()
            isRecording = true
            isPlaying = true
            startTimer()
            startWaveform()
            
        } catch {
            print("Recording error: \(error)")
        }
    }
    
    private func stopRecording() {
        recorder?.stop()
        isRecording = false
        isPlaying = false
        stopTimer()
        stopWaveform()
        
        if let url = recordingURL {
            recordedSegments.append(url)
        }
    }
    
    private func startPlayback() {
        guard let url = recordingURL else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.isMeteringEnabled = true
            player?.play()
            isPlaying = true
            
            guard let player = player else { return }
            
            startTimer()
            lblTimer.text = formatTime(currentTime)
            stopTimer()
            
            customProgressView.progress = 0
            
            playerPlaybackTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                
                if player.isPlaying {
                    let currentTime = player.currentTime
                    self.lblTimer.text = "\(self.formatTime(currentTime)) / \(self.formatTime(player.duration))"
                    
                    let progress = CGFloat(currentTime / player.duration)
                    
                    self.customProgressView.setProgress(max(progress, 0), duration: 1.1)
                    
                    if self.currentTime >= player.duration || (progress >= 0.9) {
                        timer.invalidate()
                        self.customProgressView.setProgress(1.0, duration: 0.5)
                        self.currentTime = 0
                    }
                    
                } else {
                    timer.invalidate()
                    self.isPlaying = false
                    self.customProgressView.setProgress(1.0, duration: 0.5)
                }
            }
            startWaveform()
        } catch {
            print("Playback error: \(error)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.isMeteringEnabled = false
        recordingWaveView.reset()
        stopRecording()
        btnPlayPause.setImage(UIImage(named: "ic_play"), for: .normal)
        self.lblTimer.text = "\(self.formatTime(player.duration)) / \(self.formatTime(player.duration))"
        self.customProgressView.setProgress(1.0, duration: 0.5)
        currentState = .recorded
    }
    
    private func pausePlayback() {
        player?.pause()
        isPlaying = false
        isPause = true
        stopTimer()
        stopWaveform()
    }
    
    private func startTimer() {
        stopTimer()
        
        playerPlaybackTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            
            
            guard let self = self, let recorder = self.recorder else { return }
            self.currentTime += 1
            self.lblTimer.text = self.formatTime(self.currentTime)
            recorder.updateMeters()
            let power = recorder.averagePower(forChannel: 0)
            let normalized = max(0.05, CGFloat((power + 50) / 50))
            self.customProgressView.setProgress(self.currentTime/100, duration: 0.5)
            self.recordingWaveView.add(sample: Float(normalized))
        }
    }
    
    private func stopTimer() {
        playerPlaybackTimer?.invalidate()
        playerPlaybackTimer = nil
        //  currentTime = 0
    }
    
    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startWaveform() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateWaveform))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    private func stopWaveform() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func updateWaveform() {
        if isRecording, let recorder = recorder {
            recorder.updateMeters()
            let power = recorder.averagePower(forChannel: 0)
            let linear = 1 - pow(10, power / 20)
            recordingWaveView.add(samples: [linear, linear, linear])
            
        } else if isPlaying, let player = player {
            player.updateMeters()
            let power = player.averagePower(forChannel: 0)
            let linear = 1 - pow(10, power / 20)
            recordingWaveView.add(samples: [linear, linear, linear])
        }
    }
}
