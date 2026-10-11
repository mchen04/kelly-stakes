import React from 'react';
import { motion } from 'framer-motion';
import { FileText, AlertTriangle, Scale, DollarSign, Shield, UserCheck, Ban, Globe } from 'lucide-react';

const TermsOfService = () => {
  const sections = [
    {
      title: 'Acceptance of Terms',
      content: `By downloading, installing, or using Kelly Stakes ("App"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree to these Terms, do not use the App.`
    },
    {
      title: 'Age Requirements & Legal Compliance',
      icon: UserCheck,
      content: `You must be at least 18 years old to use Kelly Stakes. By using the App, you represent and warrant that you are 18 years of age or older and have the legal capacity to enter into these Terms. 

You are responsible for ensuring that your use of the App complies with all applicable local, state, federal, and international laws and regulations, particularly those related to sports betting and gambling in your jurisdiction.`
    },
    {
      title: 'Disclaimer - Educational Tool Only',
      icon: AlertTriangle,
      isImportant: true,
      content: `IMPORTANT: Kelly Stakes is an EDUCATIONAL AND ANALYTICAL TOOL ONLY. 

The App:
• Does NOT facilitate actual betting or gambling
• Does NOT process real money transactions for betting purposes
• Does NOT guarantee profits or betting success
• Does NOT provide betting advice or tips
• Is intended solely for mathematical calculations based on the Kelly Criterion formula

Any betting decisions you make are entirely your own responsibility. Past performance calculations do not guarantee future results.`
    },
    {
      title: 'Description of Service',
      content: `Kelly Stakes provides a calculator based on the Kelly Criterion mathematical formula. The App allows users to:
• Calculate optimal bet sizing based on user-inputted odds and probabilities
• Save calculation presets for different scenarios
• Learn about the Kelly Criterion through educational content

All calculations are performed locally on your device. We do not have access to your calculations or data.`
    },
    {
      title: 'In-App Purchases',
      icon: DollarSign,
      content: `Kelly Stakes offers in-app purchases for additional preset slots at $1.99 per preset. 

• Purchases are processed through Apple's App Store
• All sales are final - no refunds except as required by law
• Purchased presets are tied to your Apple ID
• We do not have access to your payment information
• Apple's standard terms apply to all in-app purchases`
    },
    {
      title: 'Responsible Gambling Warning',
      icon: AlertTriangle,
      isImportant: true,
      content: `GAMBLING AND SPORTS BETTING INVOLVE RISK. 

• Never bet more than you can afford to lose
• Gambling can be addictive - please gamble responsibly
• If you or someone you know has a gambling problem, call 1-800-GAMBLER
• The Kelly Criterion assumes accurate probability estimates, which are difficult to achieve in practice
• Even optimal betting strategies can result in significant losses

Kelly Stakes is not responsible for any gambling losses incurred through the use of calculations made with this App.`
    },
    {
      title: 'Intellectual Property',
      icon: Shield,
      content: `All content in Kelly Stakes, including but not limited to text, graphics, logos, and software, is the property of Kelly Stakes or its licensors and is protected by copyright and other intellectual property laws. You may not reproduce, distribute, or create derivative works without our express written permission.`
    },
    {
      title: 'Limitation of Liability',
      icon: Scale,
      content: `TO THE MAXIMUM EXTENT PERMITTED BY LAW:

• Kelly Stakes and its developers SHALL NOT BE LIABLE for any direct, indirect, incidental, special, consequential, or punitive damages resulting from your use or inability to use the App
• We are NOT RESPONSIBLE for any financial losses from betting or gambling decisions
• We make NO WARRANTIES regarding the accuracy of calculations or the suitability of the Kelly Criterion for your specific situation
• Your use of the App is AT YOUR OWN RISK`
    },
    {
      title: 'Indemnification',
      content: `You agree to indemnify, defend, and hold harmless Kelly Stakes, its developers, and affiliates from any claims, losses, damages, liabilities, and expenses (including legal fees) arising from:
• Your use of the App
• Your violation of these Terms
• Your betting or gambling activities
• Your violation of any applicable laws or regulations`
    },
    {
      title: 'Prohibited Uses',
      icon: Ban,
      content: `You may NOT:
• Use the App for any illegal purposes
• Reverse engineer, decompile, or disassemble the App
• Use the App in any jurisdiction where sports betting calculators are prohibited
• Misrepresent the App's functionality as providing guaranteed betting strategies
• Use the App if you are under 18 years of age`
    },
    {
      title: 'Privacy',
      content: `Your use of Kelly Stakes is also governed by our Privacy Policy. By using the App, you consent to our privacy practices as described in the Privacy Policy.`
    },
    {
      title: 'Modifications to Terms',
      content: `We reserve the right to modify these Terms at any time. Updated Terms will be posted within the App with an updated "Last Updated" date. Your continued use of the App after any modifications constitutes acceptance of the updated Terms.`
    },
    {
      title: 'Severability',
      content: `If any provision of these Terms is found to be unenforceable or invalid, that provision shall be limited or eliminated to the minimum extent necessary so that these Terms shall otherwise remain in full force and effect.`
    },
    {
      title: 'Governing Law',
      icon: Globe,
      content: `These Terms shall be governed by and construed in accordance with the laws of the United States and the State of California, without regard to conflict of law principles. Any disputes arising under these Terms shall be subject to the exclusive jurisdiction of the courts located in California.`
    },
    {
      title: 'Contact Information',
      content: `For questions about these Terms of Service, please contact us at: kellystakesapp@gmail.com`
    }
  ];

  return (
    <section className="min-h-screen bg-black text-white py-20">
      <div className="max-w-4xl mx-auto px-4">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
        >
          <div className="text-center mb-12">
            <h1 className="text-4xl sm:text-5xl font-bold mb-4">Terms of Service</h1>
            <p className="text-gray-400">Last Updated: January 26, 2025</p>
            <p className="text-gray-400 mt-2">Effective Date: January 26, 2025</p>
          </div>

          <div className="bg-red-500/10 border border-red-500/30 rounded-2xl p-6 mb-12">
            <div className="flex items-start gap-4">
              <AlertTriangle className="w-8 h-8 text-red-400 flex-shrink-0 mt-1" />
              <div>
                <h3 className="text-xl font-bold text-red-400 mb-2">Important Legal Notice</h3>
                <p className="text-gray-300">
                  Kelly Stakes is an educational tool only. We do not facilitate betting, guarantee profits, or provide financial advice. 
                  You must be 18+ to use this app. Always gamble responsibly and within your means.
                </p>
              </div>
            </div>
          </div>

          <div className="space-y-8">
            {sections.map((section, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: index * 0.05 }}
                className={`bg-gray-900/50 backdrop-blur-sm border ${
                  section.isImportant ? 'border-yellow-500/50' : 'border-gray-800'
                } rounded-xl p-6`}
              >
                <div className="flex items-start gap-4">
                  {section.icon && (
                    <section.icon className={`w-6 h-6 ${
                      section.isImportant ? 'text-yellow-400' : 'text-green-400'
                    } flex-shrink-0 mt-1`} />
                  )}
                  <div className="flex-1">
                    <h2 className="text-2xl font-bold text-white mb-4">{section.title}</h2>
                    <div className="text-gray-300 leading-relaxed whitespace-pre-line">
                      {section.content}
                    </div>
                  </div>
                </div>
              </motion.div>
            ))}
          </div>

          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 1 }}
            className="mt-12 p-6 bg-yellow-500/10 border border-yellow-500/30 rounded-xl"
          >
            <div className="flex items-start gap-4">
              <AlertTriangle className="w-8 h-8 text-yellow-400 flex-shrink-0 mt-1" />
              <div>
                <h3 className="text-xl font-bold text-yellow-400 mb-2">Gambling Addiction Resources</h3>
                <p className="text-gray-300 mb-4">
                  If you or someone you know has a gambling problem, please seek help:
                </p>
                <ul className="space-y-2 text-gray-300">
                  <li>• National Problem Gambling Helpline: 1-800-522-4700</li>
                  <li>• National Council on Problem Gambling: ncpgambling.org</li>
                  <li>• Gamblers Anonymous: gamblersanonymous.org</li>
                  <li>• Your local state gambling helpline</li>
                </ul>
              </div>
            </div>
          </motion.div>

          <div className="mt-12 text-center">
            <p className="text-gray-500 text-sm">
              By using Kelly Stakes, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.
            </p>
          </div>
        </motion.div>
      </div>
    </section>
  );
};

export default TermsOfService;