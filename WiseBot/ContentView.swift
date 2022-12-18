//
//  ContentView.swift
//  WiseBot
//
//  Created by Kishan Kr Sharma on 12/18/22.
//
import OpenAISwift
import SwiftUI

final class ChatViewModel : ObservableObject {
    init() {}
    
    private var client: OpenAISwift?
    
    // setting up the client req
    func setup(){
        client  = OpenAISwift(authToken: "YOUR_OPEN_AI_API_KEY")
        
    }
    // sending api rext to server
    func send(text: String, completion: @escaping (String)->Void){
        client?.sendCompletion(with: text, maxTokens: 500, completionHandler: { result in
            
            switch result {
                // on request success
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(output)
                
                // on request fail
            case .failure: break
            }
            
        })
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ChatViewModel()
    
    @State var text = ""
    @State var models  = [String]()
    
    var body: some View {
        VStack(alignment: .center) {
            Text("WiseBot")
                .font(.system(.title2))
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            ScrollView (.vertical, showsIndicators: true) {
                ForEach(models, id: \.self.hashValue) { string in
                    if string.contains("Me"){
                        VStack{
                            Text("Me")
                                .font(.system(size: 11.0))
                                .foregroundColor(.blue.opacity(0.6))
                                .frame(width: UIScreen.main.bounds.width-20, alignment: .trailing)
                                .padding(.bottom, -10)
                            
                            Text(string.replacing("Me:", with: ""))
                                .foregroundColor( .white)
                                .padding(10)
                                .background(Color("me"))
                                .cornerRadius(10)
                                .frame(width: UIScreen.main.bounds.width-20, alignment: .trailing)
                            
                        }.padding(.bottom, 3)
                        
                    }else{
                        VStack{
                            Text("ChatGPT")
                                .font(.system(size: 11.0))
                                .foregroundColor(.red.opacity(0.6))
                                .frame(width: UIScreen.main.bounds.width-20, alignment: .leading)
                                .padding(.bottom, -10)
                            
                            Text(string.replacing("ChatGPT:", with: ""))
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color("bot"))
                                .cornerRadius(10)
                                .frame(width: UIScreen.main.bounds.width-20, alignment: .leading)
                            
                        }
                        
                    }
                    
                }
                
            }
            
            HStack(alignment: .center, spacing: 2){
                Button{
                    print("Broooo")
                }label: {
                    Image(systemName: "camera")
                        .font(.system(size: 25))
                }
                .padding(5)
                .cornerRadius(100)
                TextField("Type here ...", text: $text)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(.gray.opacity(0.05))
                    .cornerRadius(100)
                    .background(RoundedRectangle(cornerRadius: 100, style: .continuous)
                        .stroke(.gray.opacity(0.6), lineWidth: 1.5))
                
                Button{
                    sendApiRequest()
                }label: {
                    Image(systemName: "paperplane")
                        .font(.system(size: 25))
                }
                .padding(5)
                .cornerRadius(100)
            }
        }
        .padding(10)
        .onAppear{
            viewModel.setup()
        }.background(.white)
    }
    
    func sendApiRequest(){
        // return nothing if user types noting
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        let text2  = self.text
        self.text = ""
        models.append("Me:\(text2)")
        
        viewModel.send(text: text2) { response in
            DispatchQueue.main.async {
                self.models.append("ChatGPT:" + response.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
