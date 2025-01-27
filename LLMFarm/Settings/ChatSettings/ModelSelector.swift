import SwiftUI

struct ModelSelector: View {
    
    @Binding var models_previews: [Dictionary<String, String>]
    @Binding var model_file_path: String
    @Binding var model_file_url: URL
    @Binding var model_title: String
    @Binding var toggleSettings: Bool
    @Binding var edit_chat_dialog: Bool

    var import_lable: String
    var download_lable: String
    var selection_lable: String
    var avalible_lable: String

    @State private var isModelImporting: Bool = false
  
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Menu {
                Button {
                    Task {
                        isModelImporting = true
                    }
                } label: {
                    Label(import_lable, systemImage: "plus.app")
                }
                
                if !edit_chat_dialog {
                    Button {
                        Task {
                            toggleSettings = true
                        }
                    } label: {
                        Label(download_lable, systemImage: "icloud.and.arrow.down")
                    }
                }
                    
                Divider()
                
                Section(header: Text(avalible_lable)) {
                    ForEach(models_previews, id: \.self) { model in
                        Button(model["file_name"] ?? "") {
                            model_file_path = model["file_name"] ?? ""
                            model_title = GetFileNameWithoutExt(fileName: model_file_path)
                        }
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.purple)
                    Text(model_file_path.isEmpty ? selection_lable : model_file_path)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(10)
            }
        }
        .fileImporter(
            isPresented: $isModelImporting,
            allowedContentTypes: [.data],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                model_file_url = selectedFile
                model_file_path = selectedFile.lastPathComponent
                model_title = GetFileNameWithoutExt(fileName: selectedFile.lastPathComponent)
            } catch {
                // Handle failure.
                print("Unable to read file contents")
                print(error.localizedDescription)
            }
        }
    }
}

struct ModelSelector_Previews: PreviewProvider {
    static var previews: some View {
        ModelSelector(
            models_previews: .constant([
                ["file_name": "model1.bin"],
                ["file_name": "model2.bin"]
            ]),
            model_file_path: .constant(""),
            model_file_url: .constant(URL(string: "https://example.com/model1.bin")!),
            model_title: .constant(""),
            toggleSettings: .constant(false),
            edit_chat_dialog: .constant(false),
            import_lable: "Import from File...",
            download_lable: "Download Models...",
            selection_lable: "Select Model...",
            avalible_lable: "Available Models"
        )
        .previewLayout(.sizeThatFits)
    }
}

