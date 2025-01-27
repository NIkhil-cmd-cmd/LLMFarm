import SwiftUI

struct DownloadButton: View {
    @Binding var modelName: String
    @Binding var modelUrl: String
    @Binding var filename: String
    @Binding var status: String
    @Binding var progress: Double
    @Binding var isDownloading: Bool
    
    @State private var downloadTask: URLSessionDownloadTask?
    @State private var observation: NSKeyValueObservation?
    
    var body: some View {
        Button(action: {
            if status == "download" {
                download()
            }
        }) {
            Image(systemName: status == "downloaded" ? "checkmark.circle.fill" : "arrow.down.circle")
                .foregroundColor(status == "downloaded" ? .green : .purple)
        }
        .disabled(status == "downloading")
    }
    
    private func download() {
        guard let url = URL(string: modelUrl) else { return }
        
        isDownloading = true
        status = "downloading"
        progress = 0.0
        
        let session = URLSession.shared
        downloadTask = session.downloadTask(with: url) { localURL, _, error in
            if let localURL = localURL {
                let destinationURL = getFileURLFormPathStr(dir: "models", filename: filename)
                do {
                    try FileManager.default.moveItem(at: localURL, to: destinationURL)
                    DispatchQueue.main.async {
                        status = "downloaded"
                        isDownloading = false
                    }
                } catch {
                    print("Error:", error)
                    DispatchQueue.main.async {
                        status = "download"
                        isDownloading = false
                    }
                }
            }
        }
        
        observation = downloadTask?.progress.observe(\.fractionCompleted) { observationProgress, _ in
            DispatchQueue.main.async {
                progress = observationProgress.fractionCompleted
            }
        }
        
        downloadTask?.resume()
    }
}

