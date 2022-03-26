//
//  Created by Emilio Peláez on 26/03/22.
//

import SwiftUI

public extension View {
	/**
	 Registers an `Error` handler that will handle all `Errors` of the type
	 `AlertableError` by displaying an alert with a single dismiss button.
	 
	 __Note:__ If the error is triggered by a View contained in a sheet, this
	 modifier needs to be called inside the body of the sheet, or it will fail to
	 display the alert. This also applies to popovers and other similar modifiers.
	 
	 Example:
	 ```swift
	 @State var showSheet = true
	 var body: some View {
	   Color.primary
	   .handleAlertErrors() // This will NOT work
	   .sheet(isPresented: $showSheet) {
	   } content: {
	     ErrorGeneratingView()
	       .handleAlertErrors() // This will work
	   }
	 }
	 ```
	 */
	func handleAlertErrors() -> some View {
		modifier(AlertableErrorHandlerModifier())
	}
}
