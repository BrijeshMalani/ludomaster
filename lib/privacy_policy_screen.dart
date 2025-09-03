import 'package:flutter/material.dart';

import 'Utils/common.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.yellow,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Common.Qurekaid.isNotEmpty
                            ? const InkWell(
                                onTap: Common.openUrl,
                                child: Image(
                                  image: AssetImage(
                                    "assets/images/qurekaads.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text(
                                'Privacy Policy for Ludo Game',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Last updated: 2024',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                '1. Information We Collect',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'This privacy policy applies to the Crazy Ludo Play Online Game app (hereby referred to as "Application") for mobile devices that was created by SAMTA ENTERPRISE (hereby referred to as "Service Provider") as a Free service. This service is intended for use "AS IS".',
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Information Collection and Use',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'The Application collects information when you download and use it. This information may include information such as:\n\n'
                                '• Your device\'s Internet Protocol address (e.g. IP address)\n'
                                '• The pages of the Application that you visit, the time and date of your visit, the time spent on those pages\n'
                                '• The time spent on the Application\n'
                                '• The operating system you use on your mobile device\n\n'
                                'The Application does not gather precise information about the location of your mobile device.',
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'The Service Provider may use the information you provided to contact you from time to time to provide you with important information, required notices and marketing promotions.',
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'For a better experience, while using the Application, the Service Provider may require you to provide us with certain personally identifiable information. The information that the Service Provider request will be retained by them and used as described in this privacy policy.',
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Third Party Access',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Only aggregated, anonymized data is periodically transmitted to external services to aid the Service Provider in improving the Application and their service. The Service Provider may share your information with third parties in the ways that are described in this privacy statement.',
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Please note that the Application utilizes third-party services that have their own Privacy Policy about handling data. Below are the links to the Privacy Policy of the third-party service providers used by the Application:\n\n'
                                '• Google Play Services\n'
                                '• AdMob\n'
                                '• Google Analytics for Firebase\n'
                                '• Firebase Crashlytics',
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'The Service Provider may disclose User Provided and Automatically Collected Information:\n\n'
                                '• as required by law, such as to comply with a subpoena, or similar legal process;\n'
                                '• when they believe in good faith that disclosure is necessary to protect their rights, protect your safety or the safety of others, investigate fraud, or respond to a government request;\n'
                                '• with their trusted services providers who work on their behalf, do not have an independent use of the information we disclose to them, and have agreed to adhere to the rules set forth in this privacy statement.',
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Opt-Out Rights',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'You can stop all collection of information by the Application easily by uninstalling it. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network.',
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Data Retention Policy',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'The Service Provider will retain User Provided data for as long as you use the Application and for a reasonable time thereafter. If you\'d like them to delete User Provided Data that you have provided via the Application, please contact them at samtaenterprise1@gmail.com and they will respond in a reasonable time.',
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Children',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'The Service Provider does not use the Application to knowingly solicit data from or market to children under the age of 13.',
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'The Application does not address anyone under the age of 13. The Service Provider does not knowingly collect personally identifiable information from children under 13 years of age. In the case the Service Provider discover that a child under 13 has provided personal information, the Service Provider will immediately delete this from their servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact the Service Provider (samtaenterprise1@gmail.com) so that they will be able to take the necessary actions.',
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Security',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'The Service Provider is concerned about safeguarding the confidentiality of your information. The Service Provider provides physical, electronic, and procedural safeguards to protect information the Service Provider processes and maintains.',
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Changes',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'This Privacy Policy may be updated from time to time for any reason. The Service Provider will notify you of any changes to the Privacy Policy by updating this page with the new Privacy Policy. You are advised to consult this Privacy Policy regularly for any changes, as continued use is deemed approval of all changes.',
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'This privacy policy is effective as of 2025-08-22',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Your Consent',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'By using the Application, you are consenting to the processing of your information as set forth in this Privacy Policy now and as amended by us.',
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Contact Us',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'If you have any questions regarding privacy while using the Application, or have questions about the practices, please contact the Service Provider via email at samtaenterprise1@gmail.com',
                                style: TextStyle(fontSize: 16, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Common.Qurekaid.isNotEmpty
                    ? InkWell(
                        onTap: Common.openUrl,
                        child: Image(
                          width: MediaQuery.of(context).size.width,
                          image: const AssetImage(
                            "assets/images/bannerads.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
