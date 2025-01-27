//
//  ContactItem.swift
//  ChatUI
//
//  Created by Shezad Ahamed on 6/08/21.
//

import SwiftUI



struct ModelDownloadItem: View {
    
    @State var modelName: String
    var modelIcon: String = "square.2.layers.3d"
    @State var file_name: String = ""
    @State var orig_file_name: String = ""
    var description: String = ""
    @State var model_files: [Dictionary<String, String>] = []
    @State var download_url: String = ""
    @State var modelQuantization: String = ""
    @State var status = ""
    var modelSize: String = ""
    var modelInfo: DownloadModelInfo
    
    // Add download tracking states
    @State private var downloadProgress: Double = 0.0
    @State private var isDownloading: Bool = false
    
    init(modelInfo: DownloadModelInfo) {
        self.modelInfo = modelInfo
        self._modelName = State(initialValue: modelInfo.name ?? "Undefined")
        self._model_files = State(initialValue: modelInfo.models ?? [])
        if self.model_files.count > 0 {
            self._modelQuantization = State(initialValue: self.model_files[0]["Q"] ?? "")
            self._download_url = State(initialValue: self.model_files[0]["url"] ?? "")
            self._file_name = State(initialValue: self.model_files[0]["file_name"] ?? "")
            self._status = State(initialValue: FileManager.default.fileExists(atPath: getFileURLFormPathStr(dir: "models", filename: self.file_name).path) ? "downloaded" : "download")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Model Name and Progress
            VStack(alignment: .leading, spacing: 8) {
                Text(modelName)
                    .font(.headline)
                    .lineLimit(1)
                
                if isDownloading {
                    ProgressView(value: downloadProgress, total: 1.0)
                        .progressViewStyle(.linear)
                        .tint(.purple)
                }
            }
            
            // Description
            if !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            // Controls
            HStack {
                // Quantization Menu
                Menu {
                    Section("Quantization") {
                        ForEach(model_files, id: \.self) { model_info in
                            Button(model_info["Q"]!) {
                                file_name = model_info["file_name"] ?? ""
                                download_url = model_info["url"] ?? ""
                                modelQuantization = model_info["Q"] ?? ""
                                status = FileManager.default.fileExists(atPath: getFileURLFormPathStr(dir: "models", filename: file_name).path) ? "downloaded" : "download"
                            }
                        }
                    }
                } label: {
                    Label(modelQuantization == "" ? "Q" : modelQuantization, 
                          systemImage: "ellipsis.circle")
                        .foregroundColor(.purple)
                }
                .frame(maxWidth: 90)
                
                Spacer()
                
                // Download Status/Button
                if isDownloading {
                    Text("\(Int(downloadProgress * 100))%")
                        .foregroundColor(.purple)
                        .frame(maxWidth: 50)
                } else {
                    DownloadButton(
                        modelName: $modelName,
                        modelUrl: $download_url,
                        filename: $file_name,
                        status: $status,
                        progress: $downloadProgress,
                        isDownloading: $isDownloading
                    )
                    .frame(maxWidth: 50)
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

