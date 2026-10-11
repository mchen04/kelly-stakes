import React from 'react';
import { motion } from 'framer-motion';
import { Shield, Lock, Database, Globe, Mail, AlertCircle } from 'lucide-react';

const PrivacyPolicy = () => {
  const sections = [
    {
      title: 'Introduction',
      content: `Kelly Stakes ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains our data practices for the Kelly Stakes iOS application ("App"). We believe in complete transparency about our privacy practices, which are designed with your privacy as the top priority.`
    },
    {
      title: 'Our Privacy Commitment',
      icon: Lock,
      content: `Kelly Stakes is a 100% offline, privacy-focused application. We do not collect, store, transmit, or have access to any of your personal data, betting information, or calculation history. All data remains exclusively on your device.`
    },
    {
      title: 'Information We Do NOT Collect',
      icon: Database,
      points: [
        'Personal information (name, email, phone number)',
        'Betting history or calculation data',
        'Financial information or bankroll amounts',
        'Location data or IP addresses',
        'Device identifiers or advertising IDs',
        'Usage analytics or behavior tracking',
        'Any form of user-generated content'
      ]
    },
    {
      title: 'Data Storage',
      content: `All data entered into Kelly Stakes (bankroll amounts, odds, presets) is stored locally on your device using iOS's secure storage mechanisms. This data never leaves your device and is not accessible to us or any third parties. When you delete the app, all associated data is permanently removed from your device.`
    },
    {
      title: 'In-App Purchases',
      content: `Kelly Stakes offers in-app purchases for additional preset slots. These transactions are processed entirely through Apple's App Store infrastructure. We do not have access to your payment information, and Apple handles all transaction data according to their privacy policy. We only receive anonymous sales reports from Apple that do not identify individual users.`
    },
    {
      title: 'Third-Party Services',
      content: `Kelly Stakes does not integrate any third-party analytics, advertising, or tracking services. The only third-party service involved is Apple's App Store for app distribution and in-app purchases, which operates under Apple's privacy policy.`
    },
    {
      title: 'Age Requirements',
      icon: AlertCircle,
      content: `Kelly Stakes is intended for users aged 18 and older. We do not knowingly collect information from users under 18. The app includes educational content about mathematical betting strategies and is designed for adults who can legally participate in sports betting in their jurisdiction.`
    },
    {
      title: 'Your Rights',
      content: `Since we don't collect any personal data, there is no data to access, modify, or delete from our servers. You have complete control over your data on your device and can delete it at any time by removing the app.`
    },
    {
      title: 'Security',
      icon: Shield,
      content: `While we don't collect or transmit any data, we've designed Kelly Stakes with security in mind. All calculations happen locally on your device, and any stored presets are protected by iOS's built-in security features, including device encryption when enabled.`
    },
    {
      title: 'Changes to This Policy',
      content: `We may update this Privacy Policy from time to time. The updated version will be indicated by an updated "Last Updated" date. We encourage you to review this Privacy Policy periodically.`
    },
    {
      title: 'Contact Us',
      icon: Mail,
      content: `If you have any questions about this Privacy Policy or our privacy practices, please contact us at: kellystakesapp@gmail.com`
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
            <h1 className="text-4xl sm:text-5xl font-bold mb-4">Privacy Policy</h1>
            <p className="text-gray-400">Last Updated: January 26, 2025</p>
          </div>

          <div className="bg-green-500/10 border border-green-500/30 rounded-2xl p-6 mb-12">
            <div className="flex items-start gap-4">
              <Shield className="w-8 h-8 text-green-400 flex-shrink-0 mt-1" />
              <div>
                <h3 className="text-xl font-bold text-green-400 mb-2">Your Privacy is Our Priority</h3>
                <p className="text-gray-300">
                  Kelly Stakes operates with a zero-data-collection policy. We don't track, store, or have access to any of your personal information or betting data. Everything stays on your device.
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
                transition={{ delay: index * 0.1 }}
                className="bg-gray-900/50 backdrop-blur-sm border border-gray-800 rounded-xl p-6"
              >
                <div className="flex items-start gap-4">
                  {section.icon && (
                    <section.icon className="w-6 h-6 text-green-400 flex-shrink-0 mt-1" />
                  )}
                  <div className="flex-1">
                    <h2 className="text-2xl font-bold text-white mb-4">{section.title}</h2>
                    
                    {section.content && (
                      <p className="text-gray-300 leading-relaxed">{section.content}</p>
                    )}
                    
                    {section.points && (
                      <ul className="space-y-2 mt-4">
                        {section.points.map((point, i) => (
                          <li key={i} className="flex items-start gap-2">
                            <span className="text-red-400 mt-1">✗</span>
                            <span className="text-gray-300">{point}</span>
                          </li>
                        ))}
                      </ul>
                    )}
                  </div>
                </div>
              </motion.div>
            ))}
          </div>

          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 1 }}
            className="mt-12 p-6 bg-gray-900/50 backdrop-blur-sm border border-gray-800 rounded-xl text-center"
          >
            <Globe className="w-12 h-12 text-green-400 mx-auto mb-4" />
            <h3 className="text-xl font-bold text-white mb-2">California Consumer Privacy Act (CCPA)</h3>
            <p className="text-gray-400">
              Since Kelly Stakes does not collect any personal information, CCPA rights regarding access, deletion, and opt-out of sale of personal information are not applicable. We maintain no user data that could be accessed, modified, or sold.
            </p>
          </motion.div>

          <div className="mt-12 text-center">
            <p className="text-gray-500 text-sm">
              This privacy policy applies to the Kelly Stakes iOS application available on the Apple App Store.
            </p>
          </div>
        </motion.div>
      </div>
    </section>
  );
};

export default PrivacyPolicy;