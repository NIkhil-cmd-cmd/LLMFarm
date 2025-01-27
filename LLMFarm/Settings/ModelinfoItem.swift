//
//  ContactItem.swift
//  ChatUI
//
//  Created by Shezad Ahamed on 6/08/21.
//

import SwiftUI

struct ModelInfoItem: View {
    
    var modelIcon: String = ""
    @State var file_name: String = ""
    @State var orig_file_name: String = ""
    var description: String = ""
    var download_url: String = ""
    
    func model_name_changed(){
        let res = rename_file(orig_file_name, file_name, "models")
        if res {
            orig_file_name = file_name
        } else {
            print("Rename error!")
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: modelIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding()
                .background(Color("color_bg_inverted").opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 8) {
                Text(file_name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
}

struct ModelInfoItem_Previews: PreviewProvider {
    static var previews: some View {
        ModelInfoItem(
            modelIcon: "square.2.layers.3d",
            file_name: "model1.bin",
            orig_file_name: "model1.bin",
            description: "This is a description for model1."
        )
        .previewLayout(.sizeThatFits)
    }
}
