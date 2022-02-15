# Homework 1
## Xiangning Gao
## 998547853


**In the LaunchScreen storyboard**:
  * A launchImage is added to fullfill the Safe Area. All the top, bottom, leading and trailing constrains are set to be 0 to do so. And a Label "Awallet" is added and constrained to the proper place.

**In the Main storyboard**:
 * in Login View controller Scene:
    1. A Tap Gesture Recognizer is added to the View Controller. 
    2. the requested wording.
    3. a Textfield is added for inputting phone number
    4. A button named nextPage(the green arrow). 
* in Verification View Controller Scene:
    1. The requested wording.
    2. A label that shows requested wording with phone number
    3. 6 Textfields in a Stack
    4. The resend button
* in Home View Controller Scene:
    1. A label named "log out"
    2. A label named "Username"
    3. A label named "Total Amount"
    4. A label to display total amount
    5. A tableView
  
**In LoginViewController.swift**
  * PhoneNumberKit is imported for displaying the correct phone number format. The textField variable of the PhoneNumberTextField is declared to get the country area code from a prefix, and display a country flag according to the country area code. And placing the stored phone number into the textfield if there is one.
  * A handleTap function (a tap gesture recognizer) is added to resign the first responder which the sender is the Tap Gesture. So if the tap gesture is sent, the current textField will be ended. So, the keyboard will be dismissed.
  * A clickNextPage function (for the green arrow button) is added to do three purposes. 
     1. First is to dismiss the keyboard just like the Tap Guesture previously. 
     2. Second is to detect the errors and show the error messages. There are two kinds of errors this program detects.
            * The first one is to detect if all the inputs are digits. ClearedPhoneNumber variable will store the phone number with the country format removed and then an alart will be displayed if there's a non-digit input.
            * The second one is to detect if the input is in proper length. Since we only do U.S. numbers, the digits should be exactly 10. An alart will be displayed too if not.
     3. Third is to transit the View Controller. instantiateViewController is called to place newVC to the object of our VerificationViewController so we can replace the phoneNumString in side of the class with our fixedPhonenum(with +1 in the front). Then pushViewController is used to transit from the current controller to the newVC controller(our VerificationViewController).
     4. Forth is to transit the View Controller to the Home View Controller directly without verification if the phone number is stored.
     
**In VerificationViewController.swift** 
 * An extension is added to do substring
 * A DisplayNumberViewController class is added with an empty phoneNumString and a label that displays the phone number string in the middle. An array named fields are build according to our 6 Textfields
 * In viewDidLoad function, we set the first element in our fields function to always be the firstResponder so it will start from here as a default.
 * In didPressBackspace function, it checks if the backspace is pressed and if the current textfield isn't empty, keep cursor at current textfield and empty the textfield, if the current textfield is empty, move to the previous textfield.
 * In fieldChanged function,  first we check and void input 2 characters into 1 textfield, then if there's an existing number we will replace it with the newly input. Then if the UITextField(we have a copy or autofill) is 6 digits, it fullfills our fields's Textfield with those 6 digits, then startVerifcation function is called to do the verification. Otherwise it fills the Textfield 1 by 1 and lets the next index to be the firstResponder everytime until we get index 5. And we start the verifcation when we get to index 5.
 * In our startVerification function, codeString will equal to whatever the user input is even though the user leaves couple Textfields blank. Then we add it to verifyCode to verify if it is proper.
    1. If there's an error, an alert will be displayed according to its error type. And the Textfield will be set to empty and index 0 in our fields will be set as firstResponder.
    2. Otherwise we will prepare to switch to the next View Controller. Shared.windows.first.rootViewController is added to avoid the user going back to the previous page. And update stored token from response.
* In our resendClick function the button is added to resend the verification code by calling sendVerificationCode function.
 *
 **In HomeViewController.swift** 
  * username for UITextField, totalAmount for UILabel, and an UITableView is built for display the acounts and amount in every account.
  * build wallet and call refresh function.
  * In refresh function, we set the username and totalAmount from the storage. Then reload the tableView.
  * update IBAction function is for user to set the username. The username in storage will be updated after user pressing the update button.
  * The logout IBAction function is for the user to reset the phone number in storage.
  * the tableView function is added to replace the table row number, and the content in every row is modified too.
