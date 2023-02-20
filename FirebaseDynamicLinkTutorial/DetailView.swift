//
//  DetailView.swift
//  FirebaseDynamicLinkTutorial
//
//  Created by liam on 2023/02/21.
//

import SwiftUI
import FirebaseDynamicLinks

class AppConfig {
    static let DYNAMICLINK_SCHEME = "https"
    static let DYNAMICLINK_HOST = "firebasedynamiclinktutorial.page.link"
    
    static let DYNAMICLINK_DETEAILVIEW = "/detailview"
    static let DYNAMICLINK_DETEAILVIEW_MAKER_KEY = "maker"
    static let DYNAMICLINK_DETEAILVIEW_NAME_KEY = "name"
    
    static let BUNDLE_IDENTIFIER = Bundle.main.bundleIdentifier!
    //static let ANDROID_PACKAGE_NAME = ""
}

enum DynamicLinkError: Error {
    case createLinkError
}

struct DetailView: View {
    @State var maker: String
    @State var name: String
    
    // TODO: Dynamic Link로 넘어온 경우 ContentView로 돌아가는 Back Button 보이게 하는 법 확인.
    // TODO: App Store에 올라가지 않은 App에 대해서는 Dynamic Link가 동작하지 않는것 같은데 확인해봐야 할듯...
    
    var body: some View {
        NavigationView {
            VStack {
                Text("maker: \(maker)")
                    .frame(width: 200,
                           alignment: .leading)
                Text("name: \(name)")
                    .frame(width: 200,
                           alignment: .leading)
                Button("공유 링크 생성하기") {
                    Task {
                        let link = try! await makeShareLink() // TODO: Link 생성에 실패한 처리
                        UIPasteboard.general.string = link.absoluteString
                        print("\"\(UIPasteboard.general.string ?? "")\" is copied to clipboard.")
                    }
                }.buttonStyle(.bordered)
                    .frame(width: 200,
                           alignment: .leading)
            }
        }.navigationTitle("Detail")
    }
    
    func makeShareLink() async throws -> URL {
        // https://stackoverflow.com/questions/65339834/url-components-does-not-show-a-proper-url-swift
        
        var urlBuilder = URLComponents()
        urlBuilder.scheme = AppConfig.DYNAMICLINK_SCHEME // scheme을 분리하지 않으면 url이 정상적으로 만들어지지 않는다...
        urlBuilder.host = AppConfig.DYNAMICLINK_HOST
        
        guard let domainURIPrefix = urlBuilder.url?.absoluteString else {
            throw DynamicLinkError.createLinkError
        }
        
        urlBuilder.path = AppConfig.DYNAMICLINK_DETEAILVIEW
        urlBuilder.queryItems = [
            URLQueryItem(name: AppConfig.DYNAMICLINK_DETEAILVIEW_MAKER_KEY, value: maker),
            URLQueryItem(name: AppConfig.DYNAMICLINK_DETEAILVIEW_NAME_KEY, value: name)
        ]
        guard let link = urlBuilder.url else
        { // example: https://firebasedynamiclinktutorial.page.link/detailview?maker=Toyota&name=Car1
            throw DynamicLinkError.createLinkError
        }
        
        guard let linkBuilder = DynamicLinkComponents(
            link: link,
            domainURIPrefix: domainURIPrefix) else {
            throw DynamicLinkError.createLinkError
        }
        
        // https://firebase.google.com/docs/dynamic-links/create-manually
        // https://firebase.google.com/docs/dynamic-links/ios/create?hl=ko
        
        linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: AppConfig.BUNDLE_IDENTIFIER)
//        linkBuilder.iOSParameters?.minimumAppVersion = "1.0.0"
//        linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: AppConfig.ANDROID_PACKAGE_NAME)
//        linkBuilder.androidParameters?.minimumVersion = "1.0.0"
        
//        linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
//        linkBuilder.socialMetaTagParameters?.imageURL = URL(string: "")!
        
        
        
        guard (linkBuilder.url != nil) else {
            throw DynamicLinkError.createLinkError
        }
        
        // TODO: Short link가 뭘 의미하는지 이해하고 왜 생성 안되는지 확인.
        let (shortUrl, _) = try await linkBuilder.shorten() // just make short link and show
        print("The short url is \(shortUrl.absoluteString)") // is not parsable now
        
        return shortUrl
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(maker: "maker", name: "name")
    }
}
