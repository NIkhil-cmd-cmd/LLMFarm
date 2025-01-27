    //
//  ContactsView.swift
//  ChatUI
//
//  Created by Shezad Ahamed on 05/08/21.
//

import SwiftUI
import UniformTypeIdentifiers

struct ModelsView: View {
    
    public var dir:String
    @State var searchText: String = ""
    @State var models_previews: [Dictionary<String, String>]
    @State var model_selection: String?
    @State private var isImporting: Bool = false
    @State private var modelImported: Bool = false
    let bin_type = UTType(tag: "bin", tagClass: .filenameExtension, conformingTo: nil)
    let gguf_type = UTType(tag: "gguf", tagClass: .filenameExtension, conformingTo: nil)
    @State private var model_file_url: URL = URL(filePath: "")
    @State private var model_file_name: String = ""
    @State private var model_file_path: String = "select model"
    @State private var add_button_icon: String = "plus.app"
    var targetExts = [".gguf",".bin"]
    
    init (_ dir:String){
        self.dir = dir
        self._models_previews = State(initialValue: getFileListByExts(dir:dir,exts:targetExts)!)
    }
    
    func delete(at offsets: IndexSet) {
        let chatsToDelete = offsets.map { self.models_previews[$0] }
        _ = removeFile(chatsToDelete,dest:dir)
        models_previews = getFileListByExts(dir:dir,exts:targetExts) ?? []
    }
    
    func delete(at elem:Dictionary<String, String>){
        _  = removeFile([elem],dest:dir)
        self.models_previews.removeAll(where: { $0 == elem })
        models_previews = getFileListByExts(dir:dir,exts:targetExts) ?? []
    }
    
    private func delayIconChange() {
        // Delay of 7.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            add_button_icon = "plus.app"
        }
    }
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Add Model Button
            HStack {
                Spacer()
                Button {
                    isImporting.toggle()
                } label: {
                    Image(systemName: add_button_icon)
                        .font(.title2)
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal)
            
            // Models List
            if !models_previews.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(models_previews, id: \.self) { model in
                            ModelInfoItem(
                                modelIcon: model["icon"] ?? "",
                                file_name: model["file_name"] ?? "",
                                orig_file_name: model["file_name"] ?? "",
                                description: model["description"] ?? ""
                            )
                            .contextMenu {
                                Button(action: {
                                    delete(at: model)
                                }) {
                                    Text("Delete")
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .padding(.horizontal)
                }
            } else {
                // Empty State
                VStack {
                    Button {
                        isImporting.toggle()
                    } label: {
                        Image(systemName: "plus.square.dashed")
                            .foregroundColor(.secondary)
                            .font(.system(size: 40))
                    }
                    .buttonStyle(.borderless)
                    Text("Add model")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
                .opacity(0.6)
            }
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.data],
            allowsMultipleSelection: false
        ) { result in
            // Keep existing fileImporter implementation
            // Reference lines 98-116
        }
        .onAppear {
            models_previews = getFileListByExts(dir: dir, exts: targetExts) ?? []
        }
    }
}

//struct ContactsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModelsView()
//    }
//}

