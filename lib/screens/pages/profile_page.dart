import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/button_widget.dart';

import '../../utils/colors.dart';
import '../../widgets/text_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_back_ios_new,
                            color: secondary,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                            text: 'Back',
                            fontSize: 15,
                            color: secondary,
                            fontFamily: 'Medium',
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        TextWidget(
                          text: 'Logout',
                          fontSize: 15,
                          color: secondary,
                          fontFamily: 'Medium',
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.logout,
                          color: secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: secondary,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: CircleAvatar(
                        minRadius: 75,
                        maxRadius: 75,
                        backgroundImage: AssetImage(
                          'assets/images/sample_avatar.png',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 120, top: 110, bottom: 20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: secondary),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: TextWidget(
                text: 'Paula Baresco',
                fontSize: 28,
                color: secondary,
                fontFamily: 'Bold',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: 320,
                height: 40,
                decoration: BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Personal Information',
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                      TextWidget(
                        text: 'Edit',
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'EMAIL ADDRESS',
                    fontSize: 10,
                    color: secondary,
                    fontFamily: 'Regular',
                  ),
                  const SizedBox(
                    width: 120,
                  ),
                  TextWidget(
                    text: 'MOBILE NUMBER',
                    fontSize: 10,
                    color: secondary,
                    fontFamily: 'Regular',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Paula.baresco@gmail.com',
                    fontSize: 14,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  TextWidget(
                    text: '+6399 9999 9999',
                    fontSize: 14,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Divider(
                color: secondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextWidget(
                text: 'BIRTHDATE',
                fontSize: 10,
                color: secondary,
                fontFamily: 'Regular',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextWidget(
                text: 'January 01, 2000',
                fontSize: 14,
                color: secondary,
                fontFamily: 'Medium',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: 320,
                height: 40,
                decoration: BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Saved Addresses',
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                      TextWidget(
                        text: 'Edit',
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    home,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'HOME',
                        fontSize: 10,
                        color: secondary,
                        fontFamily: 'Regular',
                      ),
                      TextWidget(
                        text: '999 Home Street, House Avenue ',
                        fontSize: 14,
                        color: secondary,
                        fontFamily: 'Medium',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    office,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'OFFICE',
                        fontSize: 10,
                        color: secondary,
                        fontFamily: 'Regular',
                      ),
                      TextWidget(
                        text: '999 Work Street, Office Avenue, 2nd Floor ',
                        fontSize: 14,
                        color: secondary,
                        fontFamily: 'Medium',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    groups,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Sarah’s House',
                        fontSize: 10,
                        color: secondary,
                        fontFamily: 'Regular',
                      ),
                      SizedBox(
                        width: 250,
                        child: TextWidget(
                          align: TextAlign.start,
                          text:
                              '999 Friend Street, Friend Building, 2nd Floor, Room 111',
                          fontSize: 14,
                          color: secondary,
                          fontFamily: 'Medium',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: 320,
                height: 40,
                decoration: BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Payment Methods',
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    gcash,
                    width: 80,
                    height: 25,
                  ),
                  TextWidget(
                    text: '+639 9999 9999',
                    fontSize: 12,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                  Container(
                    width: 60,
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: secondary,
                    ),
                    child: Center(
                      child: TextWidget(
                        text: 'Unlink',
                        fontSize: 10,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    paymaya,
                    width: 80,
                    height: 25,
                  ),
                  const SizedBox(),
                  Container(
                    width: 60,
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: secondary,
                      ),
                    ),
                    child: Center(
                      child: TextWidget(
                        text: 'Link',
                        fontSize: 10,
                        color: secondary,
                        fontFamily: 'Medium',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        bpi,
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextWidget(
                        text: 'BPI',
                        fontSize: 15,
                        color: secondary,
                      ),
                    ],
                  ),
                  TextWidget(
                    text: '123 1234 1234',
                    fontSize: 12,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                  Container(
                    width: 60,
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: secondary,
                    ),
                    child: Center(
                      child: TextWidget(
                        text: 'Unlink',
                        fontSize: 10,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: 320,
                height: 40,
                decoration: BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Recent Transactions',
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                      TextWidget(
                        text: '',
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            for (int i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'Bluebird Coffee',
                      fontSize: 15,
                      color: secondary,
                      fontFamily: 'Bold',
                    ),
                    Column(
                      children: [
                        TextWidget(
                          text: 'Total: ₱ 800.00',
                          fontSize: 12,
                          color: secondary,
                          fontFamily: 'Medium',
                        ),
                        TextWidget(
                          text: 'July 11, 2024 11:02 AM ',
                          fontSize: 8,
                          color: secondary,
                          fontFamily: 'Regular',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                showFavorites(context);
              },
              child: tileWidget(
                'Favorites',
                const Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showPrivacy(context, 'Terms and Conditions', '''
Please read these Terms and Conditions carefully before using the Zippy Mobile Application operated by SCiVER IT Solutions.

The Terms and Conditions serve as a binding legal agreement between the Company and you, the user of this App. By using the App, you agree that you have understood and accepted the Terms and Conditions set forth herein. If you do not agree with any of the Terms and Conditions, kindly stop and refrain from using the App.
The Company reserves the right to amend and/or modify the Terms and Conditions at any time as it may deem necessary. The new terms may be displayed on-screen and you may be required to read and accept them to continue your use of the App.

The following are the terms of use of the App on your Eligible Mobile Device. An Eligible Mobile Device means a compatible wireless internet enabled mobile phone or other comparable mobile device.

1.SERVICE
The Operator is a Delivery and other Services Company and the users acknowledge the nature of business as such. The liability of the Operator shall be limited to those acts and omissions committed by the E-Commerce Act.

“VI. LIABILITY
The Operator shall exercise due diligence in accrediting and supervising its drivers. The Operator shall be held liable for acts or omissions committed by its Drivers while online, except if the same is beyond the Operator’s control.”
The Operator reserves its right to limit or suspend your account in the event of booking cancellation or fake bookings. A booking is considered canceled for purposes of application of the penalty if after the lapse of ten (10) minutes, you decide to cancel the booking without any justifiable cause.

2. LICENSES
By agreeing to these Terms and Conditions, the Operator grants you a non-exclusive, non-transferable, and personal license to use the App. The App shall be limited to your personal use, and shall not be used for commercial purposes. All rights not expressly granted to you are reserved by the Company and its licensors..

3. REPRESENTATIONS AND WARRANTIES
To the fullest extent permitted by law, the App is provided "as is" and without warranty.
You hereby warrant that you are of legal age and possess the required legal capacity to enter into contracts. You also warrant that the information you provided is accurate and true.
You further warrant and agree that:
* You shall not use the App for any unlawful purpose or for the commission of any act constituting a crime as defined under the pertinent laws of the Republic of the Philippines;
* You shall not use the App to transport hazardous chemicals or illegal drugs;
* You shall not use the App to make fake bookings;
* You shall not commit any act which tends to disrupt the operations of the App or its network;
* You shall not hack or send any malicious code, virus, or harmful data into the App;
* You agree not to copy (to the fullest extent permitted by law), decompile or reverse engineer the Software;
* You are duly informed and agree that by using the App, standard telecommunication rates or charges will apply;

4. CONSENT TO EXPORT OF PERSONAL DATA AND PRIVACY POLICY
By accepting these Terms and Conditions, you consent to your personal data being exported to the Company. Your personal data will be handled and processed in accordance with the Company’s Privacy Policy.
Additionally, by using the App and the services, you acknowledge and agree that internet transmissions are never completely private or secure. You understand that any message or information you send using the App may be read or intercepted by others, even if there is a special notice that a particular transmission is encrypted.

5. CHARGES & PAYMENT
Payment for the services shall be on a cash basis. Payment shall be made upon delivery of service intended by the user. Payment shall be given to the service provider or its employee or agent.

6. INTELLECTUAL PROPERTY, COPYRIGHT, AND TRADEMARKS
The Company shall own all rights and interests in all related intellectual property connected with the App and its software. All content included in the App, such as text, graphics, logos, button icons, images, audio clips, digital downloads, data compilations, and software, is the property of the Company and is protected by international copyright laws. The Company’s trademarks and trade name may not be used in connection with any product or service that is not that of the Company’s, in any manner that is likely to cause confusion among customers, or in any manner that disparages or discredits the Company. All other trademarks not owned by the Company or its subsidiaries that appear on the App are the property of their respective owners, who may or may not be affiliated with, connected to, or sponsored by the Company or its subsidiaries. Lastly, this statement of Terms and Conditions does not convey any ownership over intellectual property rights owned by the Company, over the App, or the software.

7. LIMITATION OF LIABILITY
In no event shall the Company, nor any of its officers, directors and employees, be held liable for anything arising out of or in any way connected with your use of the App, whether such liability is under contract. The Company, including its officers, directors and employees shall not be held liable for any indirect, consequential or special liability arising out of or in any way related to your use of the App.

8. EVENTS BEYOND THE REASONABLE CONTROL OF THE COMPANY
The Company will not be liable or responsible for any failure to perform, or delay in performance of any of its obligations under these Terms and Conditions that is caused by any act or event beyond the Company’s reasonable control, including failure of public or private telecommunications networks (“Event Outside Our Control”).
If an Event Outside Our Control takes place that affects the performance of the Company’s obligations under these Terms and Conditions, (i) the Company’s obligations under these Terms and Conditions will be suspended and the time for performance of its obligations will be extended for the duration of the Event Outside Our Control, and (ii) the Company will use its reasonable endeavours to find a solution by which its obligations under these Terms and Conditions may be performed despite the Event Outside Our Control.

9. INDEMNIFICATION
You hereby indemnify the Company to the fullest extent from and against any and/or all liabilities, costs, demands, causes of action, damages and expenses arising in any way related to your breach of any of the provisions of these Terms.

10. ENTIRE AGREEMENT
These Terms and Conditions constitute the entire agreement between the Company and you in relation to your use of the App, and supersede all prior agreements and understandings.

11. GOVERNING LAW
These Terms and Conditions will be governed by and interpreted in accordance with the laws of the Republic of the Philippines.

12. CONTACT US
If you have any questions about these Terms and Conditions, you may send an email to the Company at crm@scivercorp.com. You may also reach the Company thru their Customer Service hotline at 09XXXXXXXXX.

13. COMPLAINT MECHANISM
In case of complaints with regard to the service provided by the App and/or any of the Operator, you may contact the Company thru its Customer Service hotline at 09XXXXXXXXX. You can also send a complaint email at crm@scivercorp.com.

''');
              },
              child: tileWidget(
                'Terms and Conditions',
                TextWidget(
                  text: 'View',
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'Medium',
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showPrivacy(context, 'Privacy Policy', '''
Privacy Policy of SCIVER IT SOLUTIONS and its Mobile Application.
This Application collects some Personal Data from its Users.
 
Data Controller and Owner
SCVER IT Solutions Inc. – 3rd Floor LC Square, Balintawak St., Laoag City, Philippines
Owner contact email: crm@scivercorp.com
 
Types of Data Collected
Among the types of Personal Data that this Application collects, by itself or through third parties, there are: email address, Camera permission, Precise location permission (continuous), Approximate location permission (continuous), Microphone permission and Phone permission.
Complete details on each type of Personal Data collected are provided in the dedicated sections of this privacy policy or by specific explanation texts displayed prior to the Data collection.
The Personal Data may be freely provided by the User, or, in case of Usage Data, collected automatically when using this Application.
All Data requested by this Application is mandatory and failure to provide this Data may make it impossible for this Application to provide its services. In cases where this Application specifically states that some Data is not mandatory, Users are free not to communicate this Data without any consequences on the availability or the functioning of the service.
Users who are uncertain about which Personal Data is mandatory are welcome to contact us.
Any use of Cookies – or of other tracking tools – by this Application or by the owners of third party services used by this Application serves the purpose of providing the service required by the User, in addition to any other purposes described in the present document and in the Cookie Policy, if available.
Users are responsible for any third party Personal Data obtained, published or shared through this Application and confirm that they have the third party's consent to provide the Data to the Owner.
 
Mode and place of processing the Data
Methods of processing
The Data Controller processes the Data of Users in a proper manner and shall take appropriate security measures to prevent unauthorized access, disclosure, modification, or unauthorized destruction of the Data.
The Data processing is carried out using computers and/or IT enabled tools, following organizational procedures and modes strictly related to the purposes indicated. In addition to the Data Controller, in some cases, the Data may be accessible to certain types of persons in charge, involved with the operation of the site (administration, sales, marketing, legal, system administration) or external parties (such as third party technical service providers, mail carriers, hosting providers, IT companies, communications agencies) appointed, if necessary, as Data Processors by the company. The updated list of these parties may be requested from the Data Controller at any time.
 
 
 
Place
The Data is processed at the Data Controller's operating offices and in any other places where the parties involved with the processing are located. For further information, please contact the Data Controller.
 
Retention time
The Data is kept for the time necessary to provide the service requested by the User, or stated by the purposes outlined in this document, and the User can always request that the Data Controller suspend or remove the data.
 
The use of the collected Data
The Data concerning the User is collected to allow the Owner to provide its services, as well as for the following purposes: Access to third party accounts, Managing contacts and sending messages and Device permissions for Personal Data access.
The Personal Data used for each purpose is outlined in the specific sections of this document.
 
Facebook permissions asked by this Application
This Application may ask for some Facebook permissions allowing it to perform actions with the User's Facebook account and to retrieve information, including Personal Data, from it. This service allows this Application to connect with the User's account on the Facebook social network, provided by Facebook Inc.
For more information about the following permissions, refer to the Facebook permissions documentation and to the Facebook privacy policy.
 
The permissions asked are the following:
Basic information
By default, this includes certain User’s Data such as id, name, picture, gender, and their locale. Certain connections of the User, such as the Friends, are also available. If the User has made more of their Data public, more information will be available.
 
Email
Provides access to the User's primary email address.
 
Device permissions for Personal Data access
Depending on the User's specific device, this Application may request certain permissions that allow it to access the User's device Data as described below.
By default, these permissions must be granted by the User before the respective information can be accessed. Once the permission has been given, it can be revoked by the User at any time. In order to revoke these permissions, Users may refer to the device settings or contact the Owner for support at the contact details provided in the present document.
The exact procedure for controlling app permissions may be dependent on the User's device and software.
Please note that the revoking of such permissions might impact the proper functioning of this Application.
If User grants any of the permissions listed below, the respective Personal Data may be processed (i.e accessed to, modified or removed) by this Application.
 
Approximate location permission (continuous)
Used for accessing the User's approximate device location. This Application may collect, use, and share User location Data in order to provide location-based services.
 
Camera permission
Used for accessing the camera or capturing images and video from the device.
 
Microphone permission
Used for accessing and recording microphone audio from the User's device.
 
Phone permission
Used for accessing a host of typical features associated with telephony. This enables, for instance, read-only access to the “phone state”, which means it enables access to the phone number of the device, current mobile network information, make calls and send SMS.
 
Precise location permission (continuous)
Used for accessing the User's precise device location. This Application may collect, use, and share User location Data in order to provide location-based services.
 
Detailed information on the processing of Personal Data
Personal Data is collected for the following purposes and using the following services:
Access to third party accounts
Device permissions for Personal Data access
Managing contacts and sending messages
 
Additional information about Data collection and processing
Legal action
The User's Personal Data may be used for legal purposes by the Data Controller, in Court or in the stages leading to possible legal action arising from improper use of this Application or the related services.
The User declares to be aware that the Data Controller may be required to reveal personal data upon request of public authorities.
 
Additional information about User's Personal Data
In addition to the information contained in this privacy policy, this Application may provide the User with additional and contextual information concerning particular services or the collection and processing of Personal Data upon request. 
System logs and maintenance
For operation and maintenance purposes, this Application and any third party services may collect files that record interaction with this Application (System logs) or use for this purpose other Personal Data (such as IP Address).
 
Information not contained in this policy
More details concerning the collection or processing of Personal Data may be requested from the Data Controller at any time. Please see the contact information at the beginning of this document.
 
The rights of Users
Users have the right, at any time, to know whether their Personal Data has been stored and can consult the Data Controller to learn about their contents and origin, to verify their accuracy or to ask for them to be supplemented, cancelled, updated or corrected, or for their transformation into anonymous format or to block any data held in violation of the law, as well as to oppose their treatment for any and all legitimate reasons. Requests should be sent to the Data Controller at the contact information set out above.
This Application does not support “Do Not Track” requests.
To determine whether any of the third party services it uses honor the “Do Not Track” requests, please read their privacy policies.
 
Changes to this privacy policy
The Data Controller reserves the right to make changes to this privacy policy at any time by giving notice to its Users on this page. It is strongly recommended to check this page often, referring to the date of the last modification listed at the bottom. If a User objects to any of the changes to the Policy, the User must cease using this Application and can request that the Data Controller remove the Personal Data. Unless stated otherwise, the then-current privacy policy applies to all Personal Data the Data Controller has about Users.


''');
              },
              child: tileWidget(
                'Privacy Policy',
                TextWidget(
                  text: 'View',
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'Medium',
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showPrivacy(context, 'Developers', '''
Lorem ipsum dolor sit amet consectetur. Tortor id nulla egestas nascetur auctor aliquam lectus. Malesuada phasellus ac mattis erat mattis aliquet laoreet in sed. At velit semper nisi nibh eu. Turpis congue venenatis faucibus sed quisque leo. Pulvinar turpis sagittis lectus odio pellentesque fusce. Id pharetra in vestibulum feugiat faucibus viverra elit laoreet.
Pulvinar aenean orci dolor ultricies. Tempus purus eget accumsan facilisis. Enim tellus maecenas tellus viverra dui. Aliquam id in consectetur consequat tellus elementum tortor. Volutpat tortor aliquet ornare ullamcorper. Facilisis in tellus imperdiet mi netus scelerisque. Sem et tristique sem odio tortor vivamus tempor lorem aliquam. Quis a aliquam ut habitant id quis sed pellentesque ullamcorper. Ut diam bibendum habitant mauris amet id tempor.

''');
              },
              child: tileWidget(
                'Developers',
                TextWidget(
                  text: 'View',
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'Medium',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Center(
                child: Container(
                  width: 320,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: TextWidget(
                      text: 'Delete Account',
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: 'Bold',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget tileWidget(String title, Widget suffix) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Center(
        child: Container(
          width: 320,
          height: 40,
          decoration: BoxDecoration(
            color: secondary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: title,
                  fontSize: 15,
                  color: Colors.white,
                  fontFamily: 'Medium',
                ),
                suffix
              ],
            ),
          ),
        ),
      ),
    );
  }

  showPrivacy(context, String label, String caption) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 500,
          width: double.infinity,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: secondary,
                    size: 50,
                  ),
                  TextWidget(
                    text: label,
                    fontSize: 24,
                    color: secondary,
                    fontFamily: 'Bold',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 300,
                    width: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: secondary,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextWidget(
                          align: TextAlign.start,
                          maxLines: 500,
                          text: caption,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonWidget(
                    width: 320,
                    label: 'OKAY',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  showFavorites(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 500,
          width: double.infinity,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: secondary,
                    size: 50,
                  ),
                  TextWidget(
                    text: 'Favorites',
                    fontSize: 24,
                    color: secondary,
                    fontFamily: 'Bold',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: 'click on the heart to remove from favorites',
                    fontSize: 15,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 375,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0; i < 10; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Container(
                                width: 320,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: secondary,
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/Rectangle 40.png',
                                      height: double.infinity,
                                      width: 120,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    TextWidget(
                                      text: 'Bluebird Coffee',
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontFamily: 'Bold',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
